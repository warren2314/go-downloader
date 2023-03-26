#!/bin/bash

# Prompt the user for the package(s) to download
read -p "Enter the package(s) to download: " package_to_download

# Build the container
docker build -t my-image --build-arg PACKAGE_TO_DOWNLOAD="$package_to_download" .
docker run -v /home/ubuntu/Downloads:/output my-image

# Change the ownership of the Downloaded files
sudo chown ubuntu:ubuntu /home/ubuntu/Downloads/project.tgz # Change this to your pc name 
sudo chown ubuntu:ubuntu /home/ubuntu/Downloads/nancy-report.csv # Change this to your pc name
