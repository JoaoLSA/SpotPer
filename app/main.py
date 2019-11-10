from resources import app
import settings
# Some other example server values are
# server = 'localhost\sqlexpress' # for a named instance
# server = 'myserver,port' # to specify an alternate port


if __name__ == '__main__':
    app.run(debug=True)