import os
from flask import Flask, render_template
import pymysql


DB_HOST = os.environ.get("DB_HOST", "localhost")
DB_PORT = int(os.environ.get("DB_PORT", "3306"))
DB_USER = os.environ.get("DB_USER", "demo")
DB_PASSWORD = os.environ.get("DB_PASSWORD", "demopw")
DB_NAME = os.environ.get("DB_NAME", "demodb")

app = Flask(__name__)

# Create a single connection on first request; simple for demo purposes
_connection = None


def get_conn():
    global _connection
    if _connection is None or not _connection.open:
        _connection = pymysql.connect(
            host=DB_HOST,
            port=DB_PORT,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME,
            cursorclass=pymysql.cursors.DictCursor,
            autocommit=True,
        )
    return _connection


@app.route("/")
def index():
    conn = get_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT id, name, favorite_color FROM students ORDER BY id ASC")
        rows = cur.fetchall()
    return render_template("index.html", students=rows)


@app.route("/healthz")
def healthz():
    try:
        conn = get_conn()
        with conn.cursor() as cur:
            cur.execute("SELECT 1")
            cur.fetchone()
        return {"status": "ok"}, 200
    except Exception as e:
        return {"status": "error", "detail": str(e)}, 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)