#! /bin/bash


filename="/Users/martinmaly/AutoSpoto/AutoSpoto/Backend/text.txt"

# Define variables outside the loop
var1=""
var2=""
var3=""

# Read the file line by line and assign each line to a variable
while read -r line; do
  if [ -z "$var1" ]; then
    var1="$line"
  elif [ -z "$var2" ]; then
    var2="$line"
  else
    var3="$line"
  fi
done < "$filename"

export CACHE_PATH=$var1
export DB_STRING=$var2
export CONTACT_STRING=$var3
#export SPOTIPY_CLIENT_ID=REVOKED
#export SPOTIPY_CLIENT_SECRET=REVOKED
#export SPOTIPY_REDIRECT_URI=spotify-api-example-app://

cd /Users/martinmaly/AutoSpoto/AutoSpoto/Backend/dist
./scheduler
