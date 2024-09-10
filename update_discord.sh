# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    update_discord.sh                                  :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: dherszen <dherszen@student.42.rio>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/08/23 10:12:58 by dherszen          #+#    #+#              #
#    Updated: 2024/09/10 00:24:56 by dherszen         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
install_path="/tmp"

# Function for colored output
color_echo() {
    printf "%b%s%b\n" "$1" "$2" "$NC"
}

print_help() {
    echo "Usage: $0"
    echo "  or   $0 --help"
    echo
    echo "This script automate Discord' updates by downloading the latest Debian package and installing it."
    echo
    echo "Options:"
    echo "  --help:   Display this help message"
    echo
    echo "Examples:"
    echo "  $0        # Update Discord"
    echo "  $0 --help # Display this help message"
}

update_discord() {
    url=$(curl -I "https://discord.com/api/download?platform=linux&format=deb" 2> /dev/null | grep -i location | awk '{print $2}' | tr -d '\r')
    filename=$(basename "$url")
    color_echo "$BLUE" "Downloading the latest Discord Debian package..."
    wget "$url" -P "$install_path" -O "$filename"
    if [ $? -ne 0 ]; then
        color_echo "$RED" "Failed to download Discord package."
        exit 1
    fi

    color_echo "$BLUE" "Installing Discord..."
    # Install the package with sudo - prompts for password.
    sudo dpkg -i "${install_path}/${filename}"
    # Install the package without sudo - if running as root won't require password. Uncomment the line below and comment the line above.
#    dpkg -i "${install_path}/${filename}"
    if [ $? -ne 0 ]; then
        color_echo "$RED" "Failed to install Discord."
        exit 1
    fi

    color_echo "$GREEN" "Discord has been updated successfully."
	rm -f "${install_path}/${filename}"
}

if [ "$1" == "--help" ]; then
    print_help
    exit 0
fi

update_discord
