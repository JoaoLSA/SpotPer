import pyodbc
from flask import Flask, request, jsonify, render_template
from env import *

app = Flask(__name__)

cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+SERVER+';DATABASE='+DATABASE+';UID='+UID+';PWD='+ PWD)
cursor = cnxn.cursor()

# resource to query all playlists
@app.route("/", methods=["GET"])
@app.route("/playlist/", methods=["GET"])
def get_playlist():
     cursor.execute("SELECT * FROM playlist")
     columns = [column[0] for column in cursor.description]
     playlists = []
     for row in cursor.fetchall():
          playlists.append(dict(zip(columns, row)))
     return render_template("playlist/index.html",
     playlists=playlists)

@app.route("/playlist/<int:cod>", methods=["GET"])
def get_songs(cod = None):
     # Show playlist songs to the user
     cursor.execute("""select F.descricao from
     Faixa f, playlist p, PlaylistFaixa PF
     where
          f.cod = PF.cod_faixa and
          PF.cod_playlist = {} and
          p.cod = {}""".format(str(cod), str(cod))
     )
     columns = [column[0] for column in cursor.description]
     songs = []
     for row in cursor.fetchall():
          songs.append(dict(zip(columns, row)))
     return render_template("playlist/songs/index.html",
     content= {
               "playlist_cod": cod,
               "songs": songs
          }
     )
@app.route("/playlist/<int:cod>/add", methods=["GET"])
def add_songs(cod_playlist =None):
     cursor.execute("""
          select F.cod, F.descricao
          from
               Faixa F
          where
               f.cod = PF.cod_faixa and
               PF.cod_playlist <> {} and
               p.cod = {}""".format(str(cod_playlist), str(cod_playlist))
     )
     columns = [column[0] for column in cursor.description]
     songs = []
     for row in cursor.fetchall():
          songs.append(dict(zip(columns, row)))
     return render_template("playlist/songs/add/index.html",
     songs=songs)