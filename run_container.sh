#!/bin/sh

# Check if the image exists
image_exists=$(docker images -q go-downloader)

# Build the image if it doesn't exist
if [ -z "$image_exists" ]; then
  echo "Building the go-downloader image..."
  docker build -t go-downloader .
fi

# Run the container
docker run --rm -i --name go -v ~/Downloads:/downloads go-downloader < packages.txt

