#!/bin/sh

# Check if the image exists
image_exists=$(docker images -q go-downloader)

# Build the image if it doesn't exist
if [ -z "$image_exists" ]; then
  echo "Building the go-downloader image..."
  docker build -t go-downloader .
fi

# Prompt for the Go version once at the start
echo "Please enter the Go version you want to use for all modules (e.g., 1.21, 1.22). Press Enter for the default (1.21): "
read GO_VERSION

# Default to Go 1.21 if no version is entered
if [ -z "$GO_VERSION" ]; then
  GO_VERSION="1.21"
fi

# Validate the Go version format (e.g., 1.21, 1.22)
case $GO_VERSION in
  1.[0-9][0-9] | 1.[0-9]) ;;  # Valid version formats
  *) echo "Invalid Go version: $GO_VERSION. Please enter a valid Go version (e.g., 1.21, 1.22)." ; exit 1 ;;
esac

# Function to process a single Go module
process_module() {
  MODULE=$1

  MAJOR_GO_VERSION=$(echo "$GO_VERSION" | cut -d "." -f 1,2)
  MODULE_FOLDER_NAME=$(echo "$MODULE" | sed 's/[\/]/_/g')
  FOLDER_NAME="${GO_VERSION}_${MODULE_FOLDER_NAME}"

  mkdir -p downloads/$FOLDER_NAME
  docker run -e GO_MODULE_DOWNLOAD="$MODULE" -e GO_VERSION=$MAJOR_GO_VERSION \
    --mount type=bind,source="$(pwd)/downloads/${FOLDER_NAME}",target=/temp/downloads \
    --mount type=bind,source="$(pwd)/runtime",target=/run,readonly \
    --entrypoint /run/live-entry.sh golang:${GO_VERSION}-alpine3.19

  docker run --mount type=bind,source="$(pwd)/downloads/${FOLDER_NAME}",target=/temp/downloads \
    --entrypoint "/bin/sh" go-downloader \
    -c "cat /temp/downloads/packages.json | /go/Project1/nancy sleuth -o csv" \
    > "$(pwd)/downloads/${FOLDER_NAME}/nancy-report.csv"
}

# Check if a .txt file is provided as an argument
if [ "$1" ]; then
  if [ -f "$1" ]; then
    echo "Processing modules from $1..."
    while IFS=',' read -r MODULE; do
      process_module "$MODULE"
    done < "$1"
    exit 0
  else
    echo "File not found!"
    exit 1
  fi
fi

# Interactive input if no file is provided
while true; do
  echo "Please enter the Go module (e.g., golang.org/x/image@v0.14.0) or 'q' to quit: "
  read MODULE

  if [ "$MODULE" = "q" ]; then
    break
  fi

  # Call the function to process the module with the version
  process_module "$MODULE"
done

