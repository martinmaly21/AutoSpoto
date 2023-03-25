#! /bin/bash


filename="/Applications/autospoto/AutoSpoto/AutoSpoto/Backend/text.txt"

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

cd /Applications/autospoto/AutoSpoto/AutoSpoto/Backend/dist
./scheduler
