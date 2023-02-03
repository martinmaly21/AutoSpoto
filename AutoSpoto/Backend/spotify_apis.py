import spotipy
import os
import db

class Spotiy:

    #An instance of the class contains a connection and the user_id. All subsequent API calls can be made using these attributes and a playlist id
    
    def __init__(self):

        cache_path = os.environ['HOME'] + '/SideProjects/autoSpoto/AutoSpoto/AutoSpoto/Backend/.cache'

        auth_manager= spotipy.oauth2.SpotifyOAuth(scope="playlist-modify-public",
                                                cache_path =cache_path,
                                                show_dialog=True)

        self.conn = spotipy.Spotify(auth_manager=auth_manager)

        self.user_id = self.conn.current_user()['id']

        
    #method that creates a playlist
    #The user can pass it a name and a description
    
    def create_playlist(self, user_id, name, description, chat_id, db_object):   

        response = self.conn.user_playlist_create(user_id, name= name, public=True, collaborative=False, description= description)
        #if the playlist is succesfully created we will create a record in the sqlite db
        if response['id']:
            db_object.add_playlist(chat_id, response['id'])
        else:
            return('error something went wrong')
    
    #Updates playlist method
    def update_playlist(self, playlist_id, tracks, db_object):
        
        for index, row in enumerate(tracks): 
            tracks[index] = ('spotify:track:'+row) #append spotify:track to each of the track ids for the spotify api

        if len(tracks) > 100:
            num_of_spot_posts = int(len(tracks) / 100) # need to divide list if the tracks are more than 100
            for i in range(num_of_spot_posts+1):
                if i == (num_of_spot_posts):
                    self.conn.playlist_add_items(playlist_id, tracks[99*i:], position=None)
                    break
                self.conn.playlist_add_items(playlist_id, tracks[99*i: 99 + (100*i)], position=None)# This is just a range basically saying to upload in intervals of 100 songs
        else:
            self.conn.playlist_add_items(playlist_id, tracks, position=None)
        
        #After the songs are updated we update the time in the last updated column of the database
        db_object.update_time_playlist(playlist_id)

    #Delete playlist

    def delete_playlist(self, playlist_id, db_object):
        
        response = self.conn.current_user_unfollow_playlist(playlist_id)
        db_object.delete_playlist(playlist_id)
        return response

    
