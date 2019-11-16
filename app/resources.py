import pyodbc
from flask import Flask, request, jsonify, render_template
from env import *

app = Flask(__name__)

cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+SERVER+';DATABASE='+DATABASE+';UID='+UID+';PWD='+ PWD)
cursor = cnxn.cursor()

# resource to query all playlists
@app.route("/playlist/", methods=["GET"])
def get_playlist():
     cursor.execute("SELECT * FROM filiais")
     columns = [column[0] for column in cursor.description]
     playlists = []
     for row in cursor.fetchall():
          playlists.append(dict(zip(columns, row)))
     return render_template("playlist/index.html",
     playlists=playlists)

@app.route("/playlist/<int:cod>", methods=["GET"])
def get_songs(cod = None):
     # Show playlist songs to the user
     return render_template("playlist/index.html",
     playlists=playlists)
@app.route("/playlist/<", methods=["POST"])