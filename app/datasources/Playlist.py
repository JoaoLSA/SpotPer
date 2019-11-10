from flask import jsonify
from ..connector import cursor

class Playlist:
    # endpoint to show all users
    @app.route("/playlist", methods=["GET"])
    def get_playlist():
        all_playlists = cursor.execute("SELECT * FROM estoque")
        print(all_playlists)
        return jsonify(all_playlists)