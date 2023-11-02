#!/bin/sh

while true; do
  echo "Please enter the Go module you want without the version (or 'q' to quit): "
  read module

  if [ "$module" = "q" ]; then
    break
  fi
  
  echo "Do you want to specify a version? (y/n): "
  read specify_version

  if [ "$specify_version" = "y" ]; then

   echo "Please enter the version needed for the package: "
   read version
   go_get_command="go get $module@$version"
  else
   go_get_command="go get $module"
  fi   

  cd /go/Project1
  go clean -modcache
  $go_get_command
  cd ..
done

