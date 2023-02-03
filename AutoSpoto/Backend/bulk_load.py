import extract_script
import spotify_apis


def bulk_load(chat_id, playlist_id, spotipy_obj):
    
    spotipy_obj.update_playlist(playlist_id, extract_script.get_songs(chat_id))


   
#bulk_load(10, '0NVpZBCXYznp7BOTZelHfP', spotify_apis.Spotiy())
