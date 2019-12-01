import pyodbc
from flask import Flask, request, jsonify, render_template, redirect
from env import *

app = Flask(__name__)

cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+SERVER+';DATABASE='+DATABASE+';UID='+UID+';PWD='+ PWD)
cursor = cnxn.cursor()

# resource to query all playlists
@app.route("/", methods=["GET"])
def home():
     return redirect("/playlist/")
@app.route("/playlist/", methods=["GET"])
def get_playlist():
     cursor.execute("SELECT * FROM playlist")
     columns = [column[0] for column in cursor.description]
     playlists = []
     for row in cursor.fetchall():
          playlists.append(dict(zip(columns, row)))
     return render_template("playlist/index.html",
     content= {
               "playlists": playlists
          }
     )
@app.route("/playlist/", methods=["POST"])
def add_playlist():
     playlist_name = ''
     playlist_name = request.form.getlist('playlist_name')
     cursor.execute("""
     insert into Playlist (nome)
     output inserted.cod
     values('{}')""".format(playlist_name[0])
     )
     playlist_cod = cursor.execute("""
     select SCOPE_IDENTITY()"""
     )
     play = cursor.fetchone()
     print("playlist cod = " + str(play))
     return redirect("{}/add".format(int(play[0])), code=302)
@app.route("/playlist/<int:cod>/", methods=["GET"])
def get_songs(cod = None):
     # Show playlist songs to the user
     cursor.execute("""select F.cod, F.descricao from
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
@app.route("/playlist/<int:cod_playlist>/add/", methods=["GET"])
def list_albums(cod_playlist =None):
     cursor.execute("""
          select
          A.cod,
          A.descricao
          from
               Album A
          """
     )
     columns = [column[0] for column in cursor.description]
     albums = []
     for row in cursor.fetchall():
          albums.append(dict(zip(columns, row)))
     print(albums)
     return render_template("playlist/songs/add/index.html",
     content= {
               "cod_playlist": cod_playlist,
               "albums": albums
     })
@app.route("/playlist/<int:cod_playlist>/add/<int:cod_album>", methods=["GET"])
def songs_list(cod_playlist =None, cod_album=None):
     cursor.execute("""
     select
          F.cod,
          F.descricao
     from 
          Faixa F
     where
          F.cod_album = {} and
          F.cod not in (
	          select
                    PF.cod_faixa
               from
                    PlaylistFaixa PF
               where PF.cod_playlist = {}
	)
          """.format(cod_album, cod_playlist)
     )
     columns = [column[0] for column in cursor.description]
     songs = []
     for row in cursor.fetchall():
          songs.append(dict(zip(columns, row)))
     return render_template("playlist/songs/add/songs.html",
     songs=songs)
@app.route("/playlist/<int:cod_playlist>/add/<int:cod_album>", methods=["POST"])
def add_songs(cod_playlist =None, cod_album=None):
     separator = ','
     values = [
          "({}, {})".format(str(cod_playlist),
          str(cod_faixa[0])
          ) for cod_faixa in request.form]
     cursor.execute("""
          insert into
          PlaylistFaixa
          (cod_playlist, cod_faixa)
          values
          """+ separator.join(values)
     )
     cnxn.commit()
     return redirect("/playlist/{}/add/".format(cod_playlist, cod_album), 302)

@app.route("/playlist/<int:cod_playlist>/delete/<int:cod_song>", methods=["POST"])
def delete_song(cod_playlist = None, cod_song = None):
     cursor.execute("""
          delete from
               PlaylistFaixa
          where
               cod_playlist = {} and
               cod_faixa = {}""".format(cod_playlist, cod_song)
     )
     cnxn.commit()
     return redirect("/playlist/{}/".format(cod_playlist), 302)

@app.route("/playlist/<int:cod_playlist>/play/<int:cod_song>", methods=["POST"])
def play_song(cod_playlist = None, cod_song = None):
     cursor.execute("""
         exec play_song @playlist_cod = {}, @song_cod = {}""".format(cod_playlist, cod_song)
     )
     return redirect("/playlist/{}/?message=musica%20executada".format(cod_playlist), 302)