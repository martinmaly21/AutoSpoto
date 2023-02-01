import sqlite3
import time
import pandas as pd
import os

#pd.set_option("display.max_rows", None)
class db:
    def __init__(self):
        chat_db_string = f"\'{os.environ['HOME']}/Library/Messages/chat.db\'"
        contact_string = f"\'{os.environ["HOME"]}/Library/Application Support/AddressBook/Sources/24485206-D95C-4125-A166-735537F69AC7/AddressBook-v22.abcddb\'"


        self.connection = sqlite3.connect("/Users/andrewcaravaggio/SideProjects/songs/AutoSpoto")
        self.connection.row_factory = sqlite3.Row
        self.connection.cursor().execute("attach" +chat_db_string+ "as cdb")
        self.connection.cursor().execute("attach"+contact_string+ "as adb")

    def createTable(self):

        self.connection.cursor().execute("CREATE TABLE playlists (chat_id INTEGER, playlist_id TEXT, last_updated TEXT)")

    #When a playlist is created we keep track of current time so we do not upload songs that have already been uploaded at an earlier date

    def addPlaylist(self, chat_id, playlist_id):
        self.connection.cursor().execute("INSERT into playlists VALUES (?, ?, DateTime('now','localtime') )", (chat_id, playlist_id))
        self.connection.commit()

    #For the same reason we need to update the row when songs have been uploaded to spotify    
    def updateTimePlaylist(self, playlist_id):
        self.connection.cursor().execute("UPDATE playlists set last_updated = ? WHERE playlist_id = ?", (time.strftime("%Y-%m-%d %H:%M:%S"), playlist_id))
        self.connection.commit()

    def deletePlaylist(self, playlist_id):
        self.cursor().execute("DELETE from playlists WHERE playlist_id =?", (playlist_id,))
        self.commit()

    # This is getting all groupchats and their chat ids that have a name
    #The display_name field is blank if there is no name which is what the not like'' is doing
    def retrieveGroupChat(self):
        rows = pd.read_sql(("select ROWID as chat_id, display_name from cdb.chat where display_name not like'';"), self.connection)
        rows.dropna(subset=['display_name'], inplace=True)
        return rows

    #Here the select before the join is filtering out all of the groupchats.
    #The guid field in the chat table contians 'iMessage;-;+' followed by the phone number of the contact
    # substr(temp.guid, -12) filter outs the characters before the number
    #Format right now is +1xxxxxxxxxx for the number which is what it is in the address book as well
    def retrieveSingleChat(self):
        rows = pd.read_sql(("SELECT distinct temp.ROWID as chat_id, ZFULLNUMBER as Phone_Number, ZFIRSTNAME as First_Name, ZLASTNAME as Last_Name from  adb.ZABCDPHONENUMBER right join (SELECT * from cdb.chat where guid not like'%chat%') as temp on substr(temp.guid, -12) = ZABCDPHONENUMBER.ZFULLNUMBER left join adb.ZABCDRECORD on ZABCDPHONENUMBER.ZOWNER = ZABCDRECORD.Z_PK;"), self.connection)
        rows.dropna(subset=['Phone_Number'], inplace= True)
        #rows = rows.to_json(orient='records')
        return rows

    def closeConnection(self):
        self.connection.cursor().close()
        print('connection closed')

SC = db()
x = SC.retrieveSingleChat()
print(x)

