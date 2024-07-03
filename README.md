# Linux User Creation Bash Script

## Overview

This repository contains a bash script called `create_users.sh` that automates the process of creating users and groups on a Linux system. The script reads a text file containing usernames and group names, creates the users and groups as specified, sets up home directories with appropriate permissions and ownership, generates random passwords for the users, and logs all actions.

## Features

- Creates users and personal groups.
- Assigns users to additional groups.
- Sets up home directories with appropriate permissions.
- Generates random passwords for each user.
- Logs all actions to `/var/log/user_management.log`.
- Stores generated passwords securely in `/var/secure/user_passwords.csv`.

## Prerequisites

- A Linux system (tested on Ubuntu).
- Administrative (sudo) privileges.

## Usage

### Input File Format

The input file should contain the usernames and group names in the following format:


- Each line represents a user.
- The username is followed by a semicolon `;` and then a comma-separated list of group names.
- Each user must have a personal group with the same name as the username. This group will be created automatically if it does not exist.

### Running the Script

1. Clone the repository:

    ```bash
    git https://github.com/chiemerie386/linux-user-creation-script.git
    cd linux-user-creation-script
    ```

2. Make the script executable:

    ```bash
    chmod +x create_users.sh
    ```

3. Run the script with the input file:

    ```bash
    sudo ./create_users.sh users.txt
    ```

### Example Input File

Create a file called `users.txt` with the following content:

john;admins,developers
jane;developers
doe;admins