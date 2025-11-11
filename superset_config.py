import os
from datetime import timedelta

# Superset specific config
ROW_LIMIT = 5000

# Flask App Builder configuration
# Your App secret key will be used for securely signing the session cookie
# and encrypting sensitive information on the database
# Make sure you are changing this key for your deployment with a strong key.
# You can generate a strong key using `openssl rand -base64 42`
SECRET_KEY = os.getenv('SUPERSET_SECRET_KEY', 'your_secret_key_change_this_in_production')

# The SQLAlchemy connection string to your database backend
# This connection defines the path to the database that stores your
# superset metadata (slices, connections, tables, dashboards, ...).
SQLALCHEMY_DATABASE_URI = 'postgresql+psycopg2://superset:superset@postgres:5432/superset'

# Flask-WTF flag for CSRF
WTF_CSRF_ENABLED = True
# Add endpoints that need to be exempt from CSRF protection
WTF_CSRF_EXEMPT_LIST = []
# A CSRF token that expires in 1 year
WTF_CSRF_TIME_LIMIT = 60 * 60 * 24 * 365

# Set this API key to enable Mapbox visualizations
MAPBOX_API_KEY = os.getenv('MAPBOX_API_KEY', '')

# Redis configuration
class CeleryConfig:
    broker_url = 'redis://redis:6379/0'
    imports = ('superset.sql_lab', 'superset.tasks', 'superset.tasks.thumbnails')
    result_backend = 'redis://redis:6379/0'
    worker_prefetch_multiplier = 10
    task_acks_late = True
    task_annotations = {
        'sql_lab.get_sql_results': {
            'rate_limit': '100/s',
        },
    }

CELERY_CONFIG = CeleryConfig

# Cache configuration
CACHE_CONFIG = {
    'CACHE_TYPE': 'RedisCache',
    'CACHE_DEFAULT_TIMEOUT': 300,
    'CACHE_KEY_PREFIX': 'superset_',
    'CACHE_REDIS_HOST': 'redis',
    'CACHE_REDIS_PORT': 6379,
    'CACHE_REDIS_DB': 1,
}

# Data cache configuration
DATA_CACHE_CONFIG = {
    'CACHE_TYPE': 'RedisCache',
    'CACHE_DEFAULT_TIMEOUT': 86400,
    'CACHE_KEY_PREFIX': 'superset_data_',
    'CACHE_REDIS_HOST': 'redis',
    'CACHE_REDIS_PORT': 6379,
    'CACHE_REDIS_DB': 2,
}

# Async query configuration
FEATURE_FLAGS = {
    'ENABLE_TEMPLATE_PROCESSING': True,
}

# Set the maximum file size for uploads
MAX_CONTENT_LENGTH = 100 * 1024 * 1024  # 100 MB

# Session configuration
PERMANENT_SESSION_LIFETIME = timedelta(days=7)

# Enable/Disable public access
PUBLIC_ROLE_LIKE = 'Gamma'

# Webdriver configuration for taking screenshots and rendering thumbnails
WEBDRIVER_BASEURL = "http://superset:8088/"
WEBDRIVER_BASEURL_USER_FRIENDLY = "http://localhost:80/"

# Additional custom configuration can be added below
