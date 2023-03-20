#!/Library/Frameworks/Python.framework/Versions/3.11/bin/python3
import db
import spotify_apis
import extract_script
import pandas as pd
import spotipy
import json
import os


spot = spotify_apis.Spotiy(os.environ["CACHE_PATH"])
conn = db.db(os.environ["DB_STRING"],os.environ["CONTACT_STRING"])
#conn.add_playlist([10], '0ScAOLewbFikfkmYbYwV0Y')
#conn.add_playlist([2], '1B4IYC8kUJfjw2ZdvOnrvw')

def check_playlist_exists(playlist_id, json_to_parse, db_object):
    
    if not json_to_parse:
        return None
    elif not json_to_parse["items"]:
        return  None
    for playlist in json_to_parse["items"]:
        if playlist_id in playlist.values():
            break
    else:
        conn.delete_playlist(playlist_id)
    
    db_object.close_connection() 

def remove_del_playlist_db(spotify_obj, db_object):
    
    rows = db_object.connection.cursor().execute("Select * From playlists") #Query the database for records
    rows = rows.fetchall()
    validation_json = spotify_obj.validate_playlist(spot.user_info(), conn)

    for row in rows:
        playlist_id = row['playlist_id']
        check_playlist_exists(playlist_id, validation_json, conn)
   
    db_object.close_connection() 


def auto_update_playlist(spotify_obj, db_object):
    rows = db_object.connection.cursor().execute("Select * From playlists") #Query the database for records
    rows = rows.fetchall()

    for row in rows:
        playlist_id = row['playlist_id']
        chat_id = row['chat_id']
        last_updated = row['last_updated']
        tracks = extract_script.get_songs([chat_id], last_updated= last_updated, display_view=False, spotify_obj= spotify_obj, shouldStripInvalidIDs=True)
        if tracks:
            print(last_updated)
            spotify_obj.update_playlist(playlist_id, tracks, db_object)
        else:
            print("everything up to date")
    
    db_object.close_connection()  
#spot.create_playlist(spot.user_info(), 'Playlist 1', 'Testing scheduler', [2], conn)
#spot.create_playlist(spot.user_info(), 'Playlist 2', 'Testing scheduler', [10], conn)
#spot.create_playlist(spot.user_info(), 'Playlist 3', 'Testing scheduler', [5], conn)

remove_del_playlist_db(spot, conn)
#auto_update_playlist(spot, conn)

rows = conn.connection.cursor().execute("Select * From playlists") #Query the database for records
rows = rows.fetchall()
for row in rows:
    playlist_id = row['playlist_id']
    chat_id = row['chat_id']
    print(chat_id, playlist_id)