#!/bin/sh

echo "Enter module name:"
read MODULE

echo "Enter module version:"
read VERSION

if [ -z "$MODULE" ] || [ -z "$VERSION" ]; then
  echo "Module or version not provided. Exiting."
  exit 1
fi

echo "Downloading $MODULE@$VERSION"
echo "require $MODULE@$VERSION" >> /go/Project1/go.mod
cd /go/Project1 && go mod download

# Include the rest of your start.sh logic here


