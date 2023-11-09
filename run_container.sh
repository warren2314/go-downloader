#!/bin/sh

# Check if the image exists
image_exists=$(docker images -q go-downloader)

# Build the image if it doesn't exist
if [ -z "$image_exists" ]; then
  echo "Building the go-downloader image..."
  docker build -t go-downloader .
fi

while true; do
  echo "Please enter the Go module you want without the version (or 'q' to quit): "
  read MODULE

  if [ "$module" = "q" ]; then
    break
  fi

  echo "What version of Go? (Default 1.21): "
  read GO_VERSION

  MAJOR_GO_VERSION=$(echo "$GO_VERSION" | cut -d "." -f 1,2)

  MODULE_FOLDER_NAME=$(echo "$MODULE" | sed 's/\//_/g')
  FOLDER_NAME="${GO_VERSION}_${MODULE_FOLDER_NAME}"

  mkdir -p downloads/$FOLDER_NAME
  docker run -e GO_MODULE_DOWNLOAD="$MODULE" -e GO_VERSION=$MAJOR_GO_VERSION --mount type=bind,source="$(pwd)/downloads/${FOLDER_NAME}",target=/temp/downloads --mount type=bind,source="$(pwd)/runtime",target=/run,readonly --entrypoint /run/live-entry.sh golang:${GO_VERSION}-alpine3.17

  #go list --json -m all | /go/Project1/nancy sleuth -o csv > /go/nancy-report.csv

  #docker run --mount type=bind,source="$(pwd)/downloads/${FOLDER_NAME}",target=/temp/downloads --entrypoint "/go/Project1/nancy" go-downloader "sleuth -o csv > /temp/downloads/nancy-report.csv"
  docker run --mount type=bind,source="$(pwd)/downloads/${FOLDER_NAME}",target=/temp/downloads --entrypoint "/bin/sh" go-downloader -c "cat /temp/downloads/packages.json | /go/Project1/nancy sleuth -o csv" > "$(pwd)/downloads/${FOLDER_NAME}/nancy-report.csv"
done
