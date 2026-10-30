import os
from flask import Flask, jsonify

app = Flask(__name__)


@app.route('/health')
def health():
    return jsonify({
        'status': 'ok',
        'app': os.getenv('APP_NAME', 'api'),
        'env': os.getenv('ENV', 'development'),
        'version': open('VERSION').read().strip()
    })


@app.route('/info')
def info():
    return jsonify({
        'app': os.getenv('APP_NAME', 'api'),
        'version': open('VERSION').read().strip()
    })


if __name__ == '__main__':
    app.run(debug=os.getenv('ENV') == 'development')
