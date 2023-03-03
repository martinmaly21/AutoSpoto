import sqlite3
import time
import pandas as pd
import os
from base64 import b64encode 

#pd.set_option("display.max_rows", None)
class db:
    def __init__(self, db_string, contacts_string_id):
        chat_db_string = f"\'{os.environ['HOME']}/Library/Messages/chat.db\'"
        #is it okay to just pass in 'contacts_string_id'? I.e. will it be named AddressBook-v22.abcddb for everyone?
        contacts_string = f"\'{os.environ['HOME']}/Library/Application Support/AddressBook/Sources/{contacts_string_id}/AddressBook-v22.abcddb\'"
        self.contact_uid = contacts_string_id
        self.connection = sqlite3.connect(db_string)
        self.connection.row_factory = sqlite3.Row
        self.connection.cursor().execute("attach" +chat_db_string+ "as cdb")
        self.connection.cursor().execute("attach"+contacts_string+ "as adb")
        self.connection.cursor().execute("CREATE TABLE IF NOT EXISTS playlists (chat_id INTEGER, playlist_id TEXT, last_updated TEXT)")

    def imageAsBase64(self, image):
        if not image:
            return
        img = image[1:]  # why does Apple prepend \x01 to all images?!
        t = ''
        if img[6:10] == b'JFIF':
            t += b64encode(img).decode('ascii')
        else:
            return image
        # place 'P' manually for nice 75 char alignment
        return t

        # place 'P' manually for nice 75 char alignment
        
    def hidden_image(self, path):
    
        if path is None or len(path) > 300:
            return path
        
        else:
            path = path.decode('ascii')
            path = path.lstrip('\x02')
            path = path.rstrip('\x00')
            path =  f"{os.environ['HOME']}/Library/Application Support/AddressBook/Sources/{self.contact_uid}/.AddressBook-v22_SUPPORT/_EXTERNAL_DATA/{path}" 
            binary_fc       = open(path, 'rb').read()  # fc aka file_content
            base64_utf8_str = b64encode(binary_fc).decode('utf-8', 'ignore')
            return base64_utf8_str

    def path_to64(self, path):
        binary_fc       = open(path, 'rb').read()  # fc aka file_content
        base64_utf8_str = b64encode(binary_fc).decode('utf-8', 'ignore')
        return base64_utf8_str
    #When a playlist is created we keep track of current time so we do not upload songs that have already been uploaded at an earlier date

    def add_playlist(self, chat_id, playlist_id):
        self.connection.cursor().execute("INSERT into playlists VALUES (?, ?, ? )", (chat_id, playlist_id,None))
        self.connection.commit()

    #For the same reason we need to update the row when songs have been uploaded to spotify    
    def update_time_playlist(self, playlist_id):
        self.connection.cursor().execute("UPDATE playlists set last_updated = ? WHERE playlist_id = ?", (time.strftime("%Y-%m-%d %H:%M:%S"), playlist_id))
        self.connection.commit()

    def delete_playlist(self, playlist_id):
        self.connection.cursor().execute("DELETE from playlists WHERE playlist_id =?", (playlist_id,))
        self.connection.commit()
    
    def display_playlists(self):
        rows = pd.read_sql(("Select * From Playlists"), self.connection) #Query the database for records
        #rows = rows.to_json(orient='records')
        return rows


    # This is getting all groupchats and their chat ids that have a name
    #The display_name field is blank if there is no name which is what the not like'' is doing
    def retrieve_group_chat(self):
        directory = (os.environ['HOME']+'/Library/Intents/Images/')
        dir_list = []

        for file in os.listdir(directory):
            filename = os.fsdecode(file)
            if filename.endswith(".png"):
                dir_list.append(os.path.join(directory, filename))
                continue
            else:
                continue

        dir_panda = pd.DataFrame({'path':dir_list})
        
        rows = pd.read_sql(("select ROWID as chat_id, display_name, guid from cdb.chat where display_name not like'';"), self.connection)
        rows.dropna(subset=['display_name'], inplace=True)
        #Get the guid in the form chatxxxxxxxx so we can search the substring in the path
        rows['guid'] = rows['guid'].str.split(';').str[2]
        pat = "|".join(rows.guid)
        #Searching substring so that we add the chat guid to the directory dataframe
        dir_panda.insert(0, 'guid', dir_panda['path'].str.extract("(" + pat + ')', expand=False))
        dir_panda.dropna(subset=['guid'], inplace=True)
        #Apply the 
        dir_panda['path'] = dir_panda['path'].apply(self.path_to64)
        
        #merge the tables so that the path the base64 image in included along with chat_id, guid and display_name
        output = pd.merge(rows, dir_panda, on ='guid',  how='left')
        
        flag_check = self.display_playlists()

        final_table = pd.merge(output, flag_check, on ='chat_id',  how='left')
        final_table = final_table[['chat_id','display_name','path','playlist_id']]
        final_table.drop_duplicates(keep='first', inplace=True)
        final_table.rename({'path': 'Image'}, inplace=True, axis=1) 

        final_table = final_table.to_json(orient='records')
        return final_table

    #Here the select before the join is filtering out all of the groupchats.
    #The guid field in the chat table contians 'iMessage;-;+' followed by the phone number of the contact
    # substr(temp.guid, -12) filter outs the characters before the number
    #Format right now is +1xxxxxxxxxx for the number which is what it is in the address book as well
    def retrieve_single_chat(self):
        contact_rows = pd.read_sql(("SELECT distinct temp.ROWID as chat_id, ZFULLNUMBER as Phone_Number, ZFIRSTNAME as First_Name, ZLASTNAME as Last_Name from (SELECT * from cdb.chat where guid not like'%chat%') as temp left join adb.ZABCDPHONENUMBER on substr(temp.guid, -12) = ZABCDPHONENUMBER.ZFULLNUMBER left join adb.ZABCDRECORD on ZABCDPHONENUMBER.ZOWNER = ZABCDRECORD.Z_PK;"), self.connection)
        contact_rows.dropna(subset=['Phone_Number'], inplace= True)
        image_rows = pd.read_sql(("Select ZTHUMBNAILIMAGEDATA as Image_Blob, ZFULLNUMBER as Phone_Number from ZABCDRECORD left join ZABCDPHONENUMBER on ZABCDPHONENUMBER.ZOWNER = ZABCDRECORD.Z_PK"),self.connection)
        joined_contacts = pd.merge(image_rows, contact_rows, on ='Phone_Number',  how='inner')
        joined_contacts['Image_Blob'] = joined_contacts['Image_Blob'].apply(self.hidden_image)
        joined_contacts['Image'] = joined_contacts['Image_Blob'].apply(self.imageAsBase64)

        flag_check = self.display_playlists()

        final_table = pd.merge(joined_contacts, flag_check, on ='chat_id',  how='left')
        final_table = final_table[['Image','Phone_Number','chat_id','First_Name','Last_Name','playlist_id']]
        #### This line of code is basically grouping records by phone number and putting chat_ids grouped together into a list
        #### Meaning that a chat with sms and imessage messages will be represented as [x, x] in the chat_id column
        final_table = final_table.groupby(['Phone_Number'], dropna=False,  as_index=False).aggregate({'Image': 'first','Phone_Number':'first','chat_id': lambda x: list(x),'First_Name':'first','Last_Name':'first','playlist_id':'first'})
        final_table = final_table.to_json(orient='records')
        return final_table

    def close_connection(self):
        self.connection.cursor().close()
        print('connection closed')
