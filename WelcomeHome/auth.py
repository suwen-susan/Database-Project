import mysql.connector
from flask import (
    Blueprint, flash, g, redirect, render_template, request, url_for, current_app, session
)
from werkzeug.security import check_password_hash, generate_password_hash
from .db import get_db
from flask_login import LoginManager, UserMixin
from flask_login import login_user, logout_user, current_user, login_required

# Define your User class that extends UserMixin
class User(UserMixin):
    def __init__(self, username):
        self.username = username
        # self.email = email

    def get_id(self):
        return self.username
    
def is_staff(user):
    db = get_db()
    cursor = db.cursor()
    cursor.execute('SELECT roleID FROM Act WHERE userName = %s', (user.username,))
    roles = cursor.fetchall()
    return any(role[0] == 'staff' for role in roles)
    
def create_auth_blueprint(login_manager: LoginManager):
    bp = Blueprint('auth', __name__, url_prefix='/auth')

    #login_manager.init_app(current_app)

    @login_manager.user_loader
    def load_user(user_id):
        db = get_db()
        cursor = db.cursor()
        cursor.execute('SELECT * FROM Person WHERE userName = %s', (user_id,))
        columns = [column[0] for column in cursor.description]
        res = cursor.fetchone()
        if res is None:
            return None
        res_dict = dict(zip(columns, res))
        if len(res_dict) == 0:
            return None
        else:
            username = res_dict.get("userName")
            return User(username)
    
    @bp.route('/register', methods=('GET', 'POST'))
    def register():
        if request.method == 'POST':
            username = request.form['username']
            password = request.form['password']
            first_name = request.form['first_name']
            last_name = request.form['last_name']
            email = request.form['email']
            db = get_db()
            print(db)
            error = None
            cursor = db.cursor()
            cursor.execute("SELECT 1 FROM Person WHERE userName = %s", (username,))
            existing_user = cursor.fetchone()
            if not username:
                error = 'Username is required.'
            elif not password:
                error = 'Password is required.'
            elif (not first_name) or (not last_name):
                error = 'Name is required.'
            elif not email:
                error = 'Email is required.'
            elif existing_user:
                error = f"User {username} is already registered."

            if error is None:
                print("here")
                try:
                    cursor.execute(
                        "INSERT INTO Person (userName, password, fname, lname,email) "
                        "VALUES (%s, %s, %s, %s, %s)",
                        (username, generate_password_hash(password), first_name, last_name, email),
                    )
                    db.commit()
                except mysql.connector.IntegrityError:
                    error = f"User {username} is already registered."
                else:
                    return redirect(url_for("auth.login"))

            flash(error)

        return render_template('auth/register.html')



    @bp.route('/login', methods=('GET', 'POST'))
    def login():

        if current_user.is_authenticated:
            return redirect(url_for('auth.index'))

        if request.method == 'POST':
            username = request.form['username']
            password = request.form['password']
            db = get_db()
            cursor = db.cursor()
            error = None
            cursor.execute(
                'SELECT * FROM Person WHERE userName = %s', (username,)
            )
            columns = [column[0] for column in cursor.description]
            print(columns)
            user = cursor.fetchone()
            print(user)
            print(password)
            if user is None:
                error = 'Non-existing username'
            elif not check_password_hash(user[1], password):
                error = 'Incorrect password.'


            if error is None:
                res_dict = dict(zip(columns, user))
                # user_id = res_dict.get("cid")
                username = res_dict.get("userName")
                wrapped_user=User(username)
                login_user(wrapped_user)
                session['items'] = []
                return redirect(url_for('auth.index'))
            flash(error)

        return render_template('auth/login.html')

    @bp.route('/logout')
    def logout():
        logout_user()
        return redirect(url_for('auth.login'))

    @bp.route('/index', methods=('GET', 'POST'))
    def index():
        if is_staff(current_user):
            return redirect(url_for('func.mainpage_staff'))
        else:
            return redirect(url_for('func.mainpage_client'))

    return bp



