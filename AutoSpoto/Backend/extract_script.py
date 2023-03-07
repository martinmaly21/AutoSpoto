#!/Library/Frameworks/Python.framework/Versions/3.11/bin/python3

import sqlite3
import pandas as pd
import datetime as datetime
import re
import os
import json
import spotify_apis


#Helper function for decoding blob located withing the attributedBody column in chat.db
def split_it(url_l):

    if not url_l:
        return None

        
    url_l = url_l.decode("utf-8", "ignore")
    url_l = ''.join(url_l.split())
    #regex saying that the string must start with https://open.com/tracks/ then followed by 22 characters where the last three characters cannont be WHt
    results =  re.search('https:\/\/open\.spotify\.com\/track\/(?![a-zA-Z0-9]{19}WHt)[a-zA-Z0-9]{22}', url_l)
    
    if results != None:
        return results.group(0)
    return None
def get_songs(chat_ids, last_updated, display_view, spotify_obj):

#    last_updated = kwargs.get('last_updated', None)
#    display_view = kwargs.get('display_view', None)

    conn = sqlite3.connect(os.environ['HOME'] + '/Library/Messages/chat.db')
    cur = conn.cursor()
    cur.execute(" select name from sqlite_master where type = 'table' ") 


    messages = pd.read_sql_query('''select ROWID, text, attributedBody, date, handle_id, datetime(date/1000000000 + strftime("%s", "2001-01-01") ,"unixepoch","localtime")  as date_utc FROM message''', conn) 
    messages.rename(columns={'ROWID' : 'message_id'}, inplace = True)

    handles = pd.read_sql_query("select ROWID, id from handle", conn)
    handles.rename(columns={'id' : 'phone_number', 'ROWID': 'handle_id'}, inplace = True)

    messagesAndHandlesJoined = pd.merge(messages, handles, on ='handle_id',  how='left')

    chatMessagesJoined = pd.read_sql_query("select chat_id, message_id from chat_message_join", conn)

    chatMessagesAndHandlesJoined = pd.merge(messagesAndHandlesJoined, chatMessagesJoined, on = 'message_id', how='left')
    
    ####This code is looping through the newly created 
    houseMusicChat = []
    for chat_id in chat_ids:
        houseMusicChat.append(chatMessagesAndHandlesJoined[chatMessagesAndHandlesJoined['chat_id'] == chat_id])
    houseMusicChat = pd.concat(houseMusicChat)

    houseMusicChat = houseMusicChat[['text', 'attributedBody','date_utc']]
    # The part of the code where we can use the last updated field in the database to sync the playlist
    if last_updated:
        houseMusicChat['date_utc'] = pd.to_datetime(houseMusicChat['date_utc'], format='%Y-%m-%d %H:%M:%S')
        houseMusicChat = houseMusicChat.loc[(houseMusicChat['date_utc'] >= last_updated)] #Find all records stored after the last_updated field in the DB
   
    spotifyTrackText = 'https://open.spotify.com/track/'
   
    houseMusicChat['decoded_blob'] = houseMusicChat['attributedBody'].apply(split_it) #Applying the regex function to every blob 
    houseMusicChat.dropna(subset=['decoded_blob'], inplace= True)
    
    if display_view:
        ret_view = houseMusicChat
        ret_view = ret_view.sort_values(by = 'date_utc')
        ret_view.drop_duplicates(subset='decoded_blob', keep = 'first', inplace = True)
        if ret_view.empty:
            return('{}')
        trackIDs = ret_view['decoded_blob'].str.split('track/').str[1].tolist()
        tracks_response = spotify_obj.get_tracks(trackIDs)
        ui_json = []
        #Here we are pasing the json response and creating an object to pass to the ui
        for index in range(len(tracks_response['tracks'])):
            #right now we are passing the track_id in the form spotify:track:2QX2AOmSUydpG1IRK4xVR8, the reference image so that the user can see the album cover
            #The date the song was added and the preview url to listen to the song
            track_id = tracks_response['tracks'][index]['uri']
            image_ref = tracks_response['tracks'][index]['album']['images'][0]['url']
            
            #sometimes there isn't a preview url returned from the /tracks endpoint. In this case we will return none
            try:    
                preview_url =  tracks_response['tracks'][index]['preview_url']
            except KeyError:
                preview_url =  None
            ui_json.append(
            {
                'track_id': track_id,
                'image_ref': image_ref,
                'preview_url':  preview_url,
                'date': ret_view.iloc[index, ret_view.columns.get_loc('date_utc')] #append the date column from before
            }
            )  
        return json.dumps(ui_json)
        
        #passing the uri without spotify:track to /tracks endpoint to verify that the links are correct
        

    
    #Stripping the link so that we only have the track id
    houseMusicChat['decoded_blob'] = houseMusicChat['decoded_blob'].str.split('track/').str[1]
    
    #Removing Duplicates
    houseMusicChat.drop_duplicates(subset='decoded_blob', keep = 'first', inplace = True)
    
    #Sorting by dates
    houseMusicChat = houseMusicChat.sort_values(by = 'date_utc')

    houseMusicChat.drop_duplicates(subset='decoded_blob', keep = 'first', inplace = True)
    if houseMusicChat.empty:
        return('{}')
    #converting dataframe to list so that it may interface with the spotify API
    trackIDs = houseMusicChat['decoded_blob'].tolist()
    response = spotify_obj.get_tracks(trackIDs)
    trackIDs = []
    for track in range(len(response['tracks'])):  
        trackIDs.append(response['tracks'][track]['uri'])
    return trackIDs

# example function call for display_view of UI
x = get_songs([10], display_view=True, last_updated=False, spotify_obj = spotify_apis.Spotiy('/Users/andrewcaravaggio/SideProjects/autospoto/AutoSpoto/AutoSpoto/Backend/.cache'))
