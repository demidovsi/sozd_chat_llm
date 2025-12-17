import datetime
import os

from flask import Flask
from flask import render_template

import config

app = Flask(__name__)
app.config['SECRET_KEY'] = os.urandom(20).hex()
app.permanent = False
app.permanent_session_lifetime = datetime.timedelta(hours=24)
UPLOAD_FOLDER = 'uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    os.makedirs(UPLOAD_FOLDER, exist_ok=True)
    app.run(port=config.OWN_PORT, host=config.OWN_HOST)

