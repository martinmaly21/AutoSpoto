import sqlite3
import os
import pandas as pd
import re


def strinp_it(stringy):
    return re.sub('\D', '', stringy)

contacts_string_id = "DBD9A071-1507-4104-A7B0-9302B102B4D4"

chat_db_string = f"\'{os.environ['HOME']}/Library/Messages/chat.db\'"
        #is it okay to just pass in 'contacts_string_id'? I.e. will it be named AddressBook-v22.abcddb for everyone?
contacts_string = f"\'{os.environ['HOME']}/Library/Application Support/AddressBook/Sources/{contacts_string_id}/AddressBook-v22.abcddb\'"

connection = sqlite3.connect("", check_same_thread=False)
connection.row_factory = sqlite3.Row
connection.cursor().execute("attach" +chat_db_string+ "as cdb")
connection.cursor().execute("attach"+contacts_string+ "as adb")
contacts_string_id = "24485206-D95C-4125-A166-735537F69AC7"

rows = pd.read_sql(("select ZFULLNUMBER as Phone_Number, ZFIRSTNAME as First_Name, ZLASTNAME as Last_Name from ZABCDRECORD inner join adb.ZABCDPHONENUMBER on adb.ZABCDPHONENUMBER.ZOWNER = adb.ZABCDRECORD.Z_PK;"), connection)
rows1 = pd.read_sql(("SELECT guid, ROWID as chat_ids from cdb.chat where guid not like'%chat%';"), connection)
rows1['guid'] = rows1['guid'].apply(strinp_it)
rows['Phone_Number'] = rows['Phone_Number'].apply(strinp_it)
output = pd.merge(rows, rows1, left_on='Phone_Number', right_on='guid', how="inner")
rows.to_csv("testing1.csv", sep='\t')

