#!/bin/sh

while true; do
  echo "Please enter the Go module you want without the version (or 'q' to quit): "
  read module

  if [ "$module" = "q" ]; then
    break
  fi

  echo "Please enter the version needed for the package: "
  read version

  cd /go/Project1
  go get $module@$version
  cd ..
done

