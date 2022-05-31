import os
from app import app
from flaskext.mysql import MySQL


mysql = MySQL()
 
# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = os.environ.get("MYSQL_DATABASE_USER", "root")
app.config['MYSQL_DATABASE_PASSWORD'] = os.environ.get("MYSQL_DATABASE_PASSWORD", "redis")
app.config['MYSQL_DATABASE_DB'] = os.environ.get("MYSQL_DATABASE_DB", "acme")
app.config['MYSQL_DATABASE_HOST'] = os.environ.get("MYSQL_DATABASE_HOST", "localhost")
app.config['MYSQL_DATABASE_PORT'] = int(os.environ.get("MYSQL_DATABASE_PORT", 3306))
mysql.init_app(app)

