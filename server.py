from flask import Flask, render_template, request, flash, redirect, url_for, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
import os
import json
from datetime import datetime
from werkzeug.utils import secure_filename


app = Flask(__name__)
UPLOAD_FOLDER = 'static/images'

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+mysqlconnector://root:password@localhost:3306/new_schema'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.secret_key = 'your_secret_key_here'
db = SQLAlchemy(app)


login_manager = LoginManager(app)
login_manager.login_view = 'login'

class User(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True, nullable=False)
    login = db.Column(db.String(30), unique=True)
    password = db.Column(db.String(32))
    name = db.Column(db.String(45))
    priority = db.Column(db.Integer)
    mail = db.Column(db.String(45), unique=True)

    def __init__(self, login, password, name, priority, mail):
        self.login = login
        self.password = password
        self.name = name
        self.priority = priority
        self.mail = mail

class Survey(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True, nullable=False)
    x = db.Column(db.String(45))
    y = db.Column(db.String(45))
    category = db.Column(db.String(45))
    raiting = db.Column(db.Integer)
    comment = db.Column(db.Text)
    date = db.Column(db.DateTime, default=datetime.utcnow)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))

    def __init__(self, x, y, category, raiting, comment, date, user_id):
        self.x = x
        self.y = y
        self.category = category
        self.raiting = raiting
        self.comment = comment
        self.date = date
        self.user_id = user_id



class Media(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True, nullable=False)
    link = db.Column(db.String(45))
    survey_id = db.Column(db.Integer, db.ForeignKey('survey.id'))

    def __init__(self, link, survey_id):
        self.link = link
        self.survey_id = survey_id


class Tags(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True, nullable=False)
    tags = db.Column(db.String(45))
    survey_id = db.Column(db.Integer, db.ForeignKey('survey.id'))

    def __init__(self, tags, survey_id):
        self.tags = tags
        self.survey_id = survey_id


class Rate(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True, nullable=False)
    rate = db.Column(db.Integer)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    survey_id = db.Column(db.Integer, db.ForeignKey('survey.id'))

    def __init__(self, rate, user_id, survey_id):
        self.rate = rate
        self.user_id = user_id
        self.survey_id = survey_id


class Comments(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True, nullable=False)
    comment = db.Column(db.Text)
    date = db.Column(db.DateTime, default=datetime.utcnow)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    survey_id = db.Column(db.Integer, db.ForeignKey('survey.id'))

    def __init__(self, comment, date, user_id, survey_id):
        self.comment = comment
        self.date = date
        self.user_id = user_id
        self.survey_id = survey_id


def get_unique_filename(user_id, filename):
    extension = os.path.splitext(filename)[1]
    unique_filename = f"{user_id}_{len(os.listdir(app.config['UPLOAD_FOLDER'])) + 1}{extension}"
    return unique_filename

@app.route('/submit', methods=['POST'])
def submit():
    categoryName = request.form.get('categoryName')
    x = request.form.get('x')
    y = request.form.get('y')
    rangeValue = request.form.get('rangeValue')
    comment = request.form.get('comment')
    tags = request.form.get('tags')
    user_id = current_user.id
    
    new_survey = Survey(x=x, y=y, category=categoryName, raiting=rangeValue, comment=comment, date=datetime.utcnow(), user_id=user_id)
    db.session.add(new_survey)
    db.session.commit()
    
    for file in request.files.values():
        filename = secure_filename(file.filename)
        unique_filename = get_unique_filename(user_id, filename)
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], unique_filename))
        
        media = Media(link=unique_filename, survey_id=new_survey.id)
        db.session.add(media)
        db.session.commit()
    
    if tags:
        tag_list = tags.split(',')
        for tag in tag_list:
            new_tag = Tags(tags=tag.strip(), survey_id=new_survey.id)
            db.session.add(new_tag)
        db.session.commit()
    
    return jsonify({'message': 'Data saved successfully.'})


@app.route('/add_comment', methods=['POST'])
def add_comment():
    print(request.data)
    data = json.loads(request.data)
    comment_text = data['comment']
    survey_id = data['survey_id']
    
    comment = Comments(comment=comment_text, user_id=current_user.id, survey_id=survey_id, date=datetime.utcnow())
    db.session.add(comment)
    db.session.commit()

    return jsonify({
        'message': 'Комментарий успешно добавлен',
        'comment_id': comment.id,
        'comment_text': comment_text,
        'user_id': current_user.id,
        'survey_id': survey_id,
        'date': comment.date.strftime('%Y-%m-%d')
    })

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

@app.route('/map')
def show_map():
    if current_user.is_authenticated:
        user_id = current_user.id
    else:
        user_id = None
    surveys = Survey.query.all()
    survey_data = []
    for survey in surveys:
        survey_dict = {
            'survey_id': survey.id,
            'lat': float(survey.x),
            'lng': float(survey.y),
            'raiting': survey.raiting,
            'category': survey.category,
            'date': survey.date.date().strftime('%Y-%m-%d'),
            'comment': survey.comment,
            'tags': [],
            'media': [],
            'user_login': ''
        }
        
        tags = Tags.query.filter_by(survey_id=survey.id).all()
        media = Media.query.filter_by(survey_id=survey.id).all()
        
        for tag in tags:
            survey_dict['tags'].append(tag.tags)
        for medium in media:
            survey_dict['media'].append(medium.link)

        user = User.query.get(survey.user_id)
        if user:
            survey_dict['user_login'] = user.login
        
        survey_data.append(survey_dict)
    
    survey_json = json.dumps(survey_data)
    return render_template('map.html', surveys=survey_json, user_id=user_id)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        login = request.form['login']
        password = request.form['password']

        user = User.query.filter_by(login=login).first()
        if user and user.password == password:
            login_user(user)
            if user.priority == 1:
                return redirect(url_for('show_map'))
            else:
                return redirect(url_for('show_map'))
        else:
            flash('Invalid login or password.', 'error')
    return render_template('login_page.html')


@app.route('/admin/dashboard')
@login_required
def admin_dashboard():
    if current_user.priority != 1:
        flash('You are not authorized to access this page.', 'error')
        return redirect(url_for('user_dashboard'))
    return render_template('cabinet.html')

@app.route('/user/dashboard')
@login_required
def user_dashboard():
    if current_user.priority == 1:
        flash('You are not authorized to access this page.', 'error')
        return redirect(url_for('admin_dashboard'))
    return render_template('cabinet.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))


@app.route('/survey')
@login_required
def survey():
    return render_template('survey.html')


@app.route('/', methods=['GET', 'POST'])
def start_page():
    if request.method == 'POST':
        login = request.form['login']
        password = request.form['password']
        password2 = request.form['password2']
        name = request.form['name']
        mail = request.form['mail']

        if password != password2:
            flash('Пароли не совпадают.')
            return redirect(url_for('start_page'))

        new_user = User(login=login, password=password, name=name, priority=0, mail=mail)
        db.session.add(new_user)
        db.session.commit()
        
        flash('Пользователь успешно добавлен.')
        return redirect(url_for('login'))
    
    return render_template('register_page.html')



if __name__ == '__main__':
    app.run(debug=True, port=3307)
    #######executor.start_polling(dp, skip_updates=True)