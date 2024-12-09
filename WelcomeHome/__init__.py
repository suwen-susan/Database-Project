import os

from flask import Flask, Blueprint, redirect, url_for
from flask_mysqldb import MySQL
from flask_login import LoginManager
from .func import create_func_blueprint

def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY='dev',
    )
    app.config['MYSQL_HOST'] = 'localhost'
    app.config['MYSQL_USER'] = 'root'
    app.config['MYSQL_PASSWORD'] = '123456Abc'
    app.config['MYSQL_DB'] = 'welcomehome'
    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile('config.py', silent=True)
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass
    login_manager = LoginManager()
    login_manager.init_app(app)
    login_manager.login_view = 'auth.login'

    from . import db
    db.init_app(app)
    from .auth import create_auth_blueprint
    auth_bp = create_auth_blueprint(login_manager)
    app.register_blueprint(auth_bp)
    # app.add_url_rule('/', endpoint='auth.login')

    @app.route("/", methods=("GET", "POST"))
    def home():
        return redirect(url_for('auth.login'))
    
    func_bp = create_func_blueprint()
    app.register_blueprint(func_bp)

    return app