#!/Library/Frameworks/Python.framework/Versions/3.11/bin/python3
import extract_script #import the script that accesses the chat.db
import db
import spotify_apis
import os


#This is the script for automatically updating the spotify playlists
#Each row from the DB will be queried and then the chat corresponding to the playlist will be read
#If there are new songs since the last update, they will be added to spotify
        
#instatiate spotify class
spot = spotify_apis.Spotiy()
conn = db.db() #connection to the databse
rows = conn.connection.cursor().execute("Select * From Playlists") #Query the database for records
rows = rows.fetchall()

for row in rows:
    playlist_id = row['playlist_id']
    chat_id = row['chat_id']
    last_updated = row['last_updated']

    tracks = extract_script.get_songs(chat_id,last_updated) #calling the getSongs function from the extract_script module

    if tracks: #if the getSongs function returns none it means that no new songs have been sent in the chat
        spot.update_playlist(playlist_id, tracks)
        conn.update_time_playlist(playlist_id)  
    else:
        print('no new songs from playlist')
        print(last_updated)

conn.close_connection()