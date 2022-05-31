import os
import redis
from flask import Flask
from flask_session import Session

app = Flask(__name__)
app.secret_key = "secret key"


# Configure Redis for storing the session data on the server-side
redishost = os.environ.get("REDISHOST", "localhost")
redisport = os.environ.get("REDISPORT", "6379")
redispassword = os.environ.get("REDISPASSWORD", "password")
redis_endpoint = 'redis://:' + redispassword + '@' + redishost + ':' + redisport

app.config['SESSION_TYPE'] = 'redis'
app.config['SESSION_PERMANENT'] = False
app.config['SESSION_USE_SIGNER'] = True
app.config['SESSION_REDIS'] = redis.from_url(redis_endpoint)

# Create and initialize the Flask-Session object AFTER `app` has been configured
server_session = Session(app)
