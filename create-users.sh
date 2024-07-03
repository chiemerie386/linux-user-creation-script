#!/bin/bash

# Log file
LOGFILE="/var/log/user_management.log"

# Password file
PASSWORD_FILE="/var/secure/user_passwords.csv"

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOGFILE
}

# Function to generate a random password
generate_password() {
    tr -dc A-Za-z0-9 </dev/urandom | head -c 16
}

# Ensure the password file is created and secure
if [ ! -d "/var/secure" ]; then
    mkdir -p /var/secure
    chmod 700 /var/secure
fi
touch $PASSWORD_FILE
chmod 600 $PASSWORD_FILE

# Check if the input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

INPUT_FILE="$1"

# Read the input file line by line
while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and lines starting with #
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Parse username and groups
    IFS=';' read -r username groups <<< "$line"
    username=$(echo "$username" | xargs) # Trim whitespace

    # Skip if username is empty
    [ -z "$username" ] && continue

    # Create personal group
    if ! getent group "$username" >/dev/null; then
        groupadd "$username"
        log "Created group $username"
    fi

    # Create user with personal group
    if ! id -u "$username" >/dev/null 2>&1; then
        password=$(generate_password)
        useradd -m -g "$username" "$username"
        echo "$username:$password" | chpasswd
        echo "$username:$password" >> $PASSWORD_FILE
        log "Created user $username with password"
    else
        log "User $username already exists"
    fi

    # Process additional groups
    IFS=',' read -r -a group_array <<< "$groups"
    for group in "${group_array[@]}"; do
        group=$(echo "$group" | xargs) # Trim whitespace
        [ -z "$group" ] && continue

        # Create group if it does not exist
        if ! getent group "$group" >/dev/null; then
            groupadd "$group"
            log "Created group $group"
        fi

        # Add user to the group
        usermod -aG "$group" "$username"
        log "Added $username to group $group"
    done
done < "$INPUT_FILE"

log "User and group creation process completed."
