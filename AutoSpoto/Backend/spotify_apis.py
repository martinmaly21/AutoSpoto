import spotipy
import os
import db
import time
import requests
from requests.exceptions import RequestException
import urllib3
import socket

class Spotiy:

    #An instance of the class contains a connection and the user_id. All subsequent API calls can be made using these attributes and a playlist id
    
    def __init__(self, cache_path):
        auth_manager= spotipy.oauth2.SpotifyOAuth(scope="playlist-modify-public",
                                                cache_path =cache_path,
                                                show_dialog=True)

        self.conn = spotipy.Spotify(auth_manager=auth_manager)
        
    def user_info(self):
        
        try:
            socket.gethostbyname('api.spotify.com')
            user_info = self.conn.current_user()
            if user_info['id']:
                return user_info['id']
            else:
                raise Exception(response['error'])
        except (socket.gaierror, RequestException, urllib3.exceptions.MaxRetryError, urllib3.exceptions.NameResolutionError) as e:
            return None
        except spotipy.SpotifyException as response:
            return None
    
    def clean_nones(self, json_data):

        #this function removes all of the Nones from the JSON. When a broken uri is sent to the tracks endpoint the response is None
        if isinstance(json_data, list):
            return [self.clean_nones(x) for x in json_data if x is not None]
        elif isinstance(json_data, dict):
            return {
                key: self.clean_nones(val)
                for key, val in json_data.items()
                if val is not None
            }
        else:
            return json_data
    
    def get_tracks(self, tracks):
        
        try:
            socket.gethostbyname('api.spotify.com')
            if len(tracks) > 50:
                #The spotify api has a limit for 50 track requests
                num_of_spot_posts = len(tracks) // 50 
                for i in range(num_of_spot_posts+1):
                    if i == 0 :
                        response = self.clean_nones(self.conn.tracks(tracks[0: 50]))
                    
                    
                    elif i == (num_of_spot_posts) and tracks[50*i:]:
                        response["tracks"] += self.clean_nones(self.conn.tracks(tracks[50*i:]))["tracks"]
                        break
                    elif tracks[50*i: 50 + (50*i)]:
                        response["tracks"] += self.clean_nones(self.conn.tracks(tracks[50*i: 50 + (50*i)]))["tracks"]
                
            else:
                response = self.clean_nones(self.conn.tracks(tracks))

            return response
        except (socket.gaierror, RequestException, urllib3.exceptions.MaxRetryError, urllib3.exceptions.NameResolutionError) as e:
            return None
        except spotipy.SpotifyException as response:
            return None
    
    #method that creates a playlist
    #The user can pass it a name and a description
    def create_playlist(self, user_id, name, description, chat_ids, db_object):
        try:
            socket.gethostbyname('api.spotify.com')
            response = self.conn.user_playlist_create(user_id, name= name, public=True, collaborative=False, description= description)
            #if the playlist is succesfully created we will create a record in the sqlite db
            if response['id']:
                db_object.add_playlist(chat_ids, response ['id'])
                return response['id']
            else:
                return None
        except (socket.gaierror, RequestException, urllib3.exceptions.MaxRetryError, urllib3.exceptions.NameResolutionError) as e:
            return None
        except spotipy.SpotifyException as response:
            return None
        
    
    #Updates playlist method
    def update_playlist(self, playlist_id, tracks, db_object):
        try:
            socket.gethostbyname('api.spotify.com')
            if len(tracks) > 100:
                num_of_spot_posts = int(len(tracks) / 100) # need to divide list if the tracks are more than 100
                for i in range(num_of_spot_posts):
                    if i == (num_of_spot_posts):
                        response = self.conn.playlist_add_items(playlist_id, tracks[100*i:], position=None)
                        break
                    self.conn.playlist_add_items(playlist_id, tracks[100*i: 100 + (100*i)], position=None)# This is just a range basically saying to upload in intervals of 100 songs
                    
            else:
                response = self.conn.playlist_add_items(playlist_id, tracks, position=None)
            
            #After the songs are updated we update the time in the last updated column of the database
            if response['snapshot_id']:
                db_object.update_time_playlist(playlist_id)
            else:
                raise Exception(response['error'])
        except (socket.gaierror, RequestException, urllib3.exceptions.MaxRetryError, urllib3.exceptions.NameResolutionError) as e:
            return None
        except spotipy.SpotifyException as response:
            return None

    #Delete playlist

    def delete_playlist(self, playlist_id, db_object):
        try:
            socket.gethostbyname('api.spotify.com')
            response = self.conn.current_user_unfollow_playlist(playlist_id)
            if response is None:
                db_object.delete_playlist(playlist_id)
            else:
                return None

        except spotipy.SpotifyException as response:
            return None
        except (socket.gaierror, RequestException, urllib3.exceptions.MaxRetryError, urllib3.exceptions.NameResolutionError) as e:
            return None
    def validate_playlist(self, user_id, db_object):
        try:
            socket.gethostbyname('api.spotify.com')
            response = self.conn.user_playlists(user_id)
            return response
        
        #In this case the playlist id is not found on the users account
        except spotipy.SpotifyException as response:
            return None
        except (socket.gaierror, RequestException, urllib3.exceptions.MaxRetryError, urllib3.exceptions.NameResolutionError) as e:
            return None
        #This exception is raised if there is an issue with the users internet connection
        
