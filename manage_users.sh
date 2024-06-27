#!/bin/bash

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Input file
input_file="usernames.csv"

# Check if the input file exists
if [[ ! -f $input_file ]]; then
    echo "Error: File '$input_file' not found."
    exit 1
fi

# Read the CSV file and create users
while IFS="," read -r username group permission; do
    # Create group if it does not exist
    if ! getent group "$group" >/dev/null; then
        groupadd "$group"
    fi

    # Create user with the specified group
    useradd -m -d "/home/$username" -g "$group" "$username"
a
    # Set the permissions for the user's home directory
    chmod "$permission" "/home/$username"

    # Create the projects directory
    user_home="/home/$username"
    
    mkdir -p "$user_home/projects"

    # Create the README.md file with a personalized message
    echo "Welcome, $username! we are Spider R&D." > "$user_home/projects/README.md"

    # Set ownership to the user and group
    chown -R "$username:$group" "$user_home"

done < "$input_file"

echo "User setup completed successfully."

