# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    update_discord.sh                                  :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: dherszen <dherszen@student.42.rio>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/08/23 10:12:58 by dherszen          #+#    #+#              #
#    Updated: 2024/09/10 00:40:33 by dherszen         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
install_path="/tmp"
use_sudo=true

# Function for colored output
color_echo() {
    printf "%b%s%b\n" "$1" "$2" "$NC"
}

print_help() {
    echo "Usage: $0 [--no-sudo]"
    echo "  or   $0 --help"
    echo
    echo "This script automates Discord updates by downloading the latest Debian package and installing it."
    echo
    echo "Options:"
    echo "  --help:    Display this help message"
    echo "  --no-sudo: Install Discord without using sudo"
    echo
    echo "Examples:"
    echo "  $0          # Update Discord with sudo"
    echo "  $0 --no-sudo # Update Discord without sudo"
    echo "  $0 --help   # Display this help message"
}

update_discord() {
    local url=""
    local filename=""
    
    cd ${install_path}
    url=$(curl -I "https://discord.com/api/download?platform=linux&format=deb" 2> /dev/null | grep -i location | awk '{print $2}' | tr -d '\r')
    filename=$(basename "$url")
    color_echo "$BLUE" "Downloading the latest Discord Debian package..."
    wget "$url" -O "$filename"
    if [ $? -ne 0 ]; then
        color_echo "$RED" "Failed to download Discord package."
        exit 1
    fi

    color_echo "$BLUE" "Installing Discord..."
    if [ "$use_sudo" = true ]; then
    	cd ${install_path}
        sudo dpkg -i "${filename}"
    else
    	cd ${install_path}
        dpkg -i "${filename}"
    fi

    if [ $? -ne 0 ]; then
        color_echo "$RED" "Failed to install Discord."
        exit 1
    fi

    color_echo "$GREEN" "Discord has been updated successfully."

    color_echo "$RED" "Deleting $filename"
    rm "$filename"
    
    if [ $? -ne 0 ]; then
        color_echo "$RED" "Failed to delete Discord."
        exit 1
    fi

}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --help) print_help; exit 0 ;;
        --no-sudo) use_sudo=false ;;
        *) echo "Unknown parameter passed: $1"; print_help; exit 1 ;;
    esac
    shift
done

update_discord
