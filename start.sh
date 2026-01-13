#!/bin/bash

java --version

if [ ! -d '/server/downloader' ]; then
    mkdir '/server/downloader'
fi 

# Download the downloader
if [ ! -f '/server/downloader/hytale-downloader-linux-amd64' ]; then
    echo 'hytale-downloader not found, downloading...'

    downloadUrl='https://downloader.hytale.com/hytale-downloader.zip'
    curl -fsSL "$downloadUrl" -o /tmp/hytale-downloader.zip
    if [ $? -ne 0 ]; then
        echo "Failed to download Hytale downloader"
        exit 100
    fi
    
    echo 'Unzipping hytale-downloader.zip...'
    unzip -d /server/downloader /tmp/hytale-downloader.zip
    if [ $? -ne 0 ]; then
        echo "Failed to unzip hytale-downloader.zip"
        exit 110
    fi

    # cleanup
    rm /tmp/hytale-downloader.zip

    if [ ! -f '/server/downloader/hytale-downloader-linux-amd64' ]; then
        echo "'hytale-downloader-linux-amd64' not found after downloading."
        exit 150
    fi

fi

# Download server
if [ ! -f '/server/HytaleServer.jar' ]; then
    echo "Downloader Version $(/server/downloader/hytale-downloader-linux-amd64 -version)"
    /server/downloader/hytale-downloader-linux-amd64 --download-path /tmp/server.zip
    if [ $? -ne 0 ]; then
        echo "Failed to download Hytale"
        exit 200
    fi

    echo 'Unzipping server.zip...'
    unzip -o -d /tmp/server /tmp/server.zip
    if [ $? -ne 0 ]; then
        echo "Failed to unzip server.zip"
        exit 210
    fi

    echo 'Copying server files...'
    cp -rf /tmp/server/Server/* /tmp/server/Assets.zip /server
    if [ $? -ne 0 ]; then
        echo "Failed to copy server files"
        exit 220
    fi

    # cleanup
    rm -rf /tmp/server/ /tmp/server.zip

    if [ ! -f '/server/HytaleServer.jar' ]; then
        echo "'HytaleServer.jar' not found after downloading."
        exit 250
    fi
fi

# Ensure we're in the /server dir
if [[ "$current_dir_name" != "/server" ]]; then
    cd /server
fi

if [[ "$EUID" == "0" ]]; then
   echo "WARNING! Running the server as root is NOT reccomended."
   echo "If this is not intentional, check your docker config."
   exit 1000
fi

# Start the server
java -jar HytaleServer.jar --assets /server/Assets.zip $@