import pyodbc
from flask import Flask, request, jsonify
from env import *

app = Flask(__name__)

cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+SERVER+';DATABASE='+DATABASE+';UID='+UID+';PWD='+ PWD)
cursor = cnxn.cursor()

# endpoint query all playlists
@app.route("/playlist", methods=["GET"])
def get_playlist():
    cursor.execute("SELECT * FROM filiais")
    columns = [column[0] for column in cursor.description]
    print(columns)
    results = []
    for row in cursor.fetchall():
         results.append(dict(zip(columns, row)))
    print(results)
    return jsonify(results)