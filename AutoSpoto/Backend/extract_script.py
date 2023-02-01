#!/Library/Frameworks/Python.framework/Versions/3.11/bin/python3

import sqlite3
import pandas as pd
import datetime as datetime
import numpy as np
from urllib import parse
import re
import os


#Helper function for decoding blob located withing the attributedBody column in chat.db
def split_it(url_l):

    if not url_l:
        return none

        
    url_l = url_l.decode("utf-8", "ignore")
    url_l = ''.join(url_l.split())
    results =  re.search('https.+?(?=[?])', url_l)

    if results != None:
        return results.group()
    return None

def get_songs(chat_id, last_updated):


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

    houseMusicChat = chatMessagesAndHandlesJoined[chatMessagesAndHandlesJoined['chat_id'] == chat_id]
    
    houseMusicChat = houseMusicChat[['text', 'attributedBody','date_utc']]
    

    # The part of the code where we can use the last updated field in the database to sync the playlist
    houseMusicChat['date_utc'] = pd.to_datetime(houseMusicChat['date_utc'], format='%Y-%m-%d %H:%M:%S')
    houseMusicChat = houseMusicChat.loc[(houseMusicChat['date_utc'] >= last_updated)] #Find all records stored after the last_updated field in the DB

    spotifyTrackText = 'https://open.spotify.com/track/'

    houseMusicChat['decoded_blob'] = houseMusicChat['attributedBody'].apply(split_it) #Applying the regex function to every blob 

    houseMusicChat = houseMusicChat[houseMusicChat['decoded_blob'].str.startswith(spotifyTrackText) == True] #Keep only the rows that have a spotify song in them

    trackIDs = []

    for url in houseMusicChat['decoded_blob'].to_numpy():
        path = parse.urlparse(url).path
        trackIDs.append(path.rpartition('/')[2])

    trackIdsWithoutDuplicates = sam_list = list(set(trackIDs)) 
    return trackIdsWithoutDuplicates
