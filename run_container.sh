#!/bin/bash

echo "Please enter the Go module you want without the version: "
read module
echo "Please enter the version needed for the package: "
read version

docker build -t go-downloader .

docker run --name go -e MODULE=$module -e VERSION=$version -v $(pwd):/downloads go-downloader /bin/sh -c "\
  cd /go/Project1; \
  go get \$MODULE@\$VERSION; \
  go list --json -m all | ../nancy/nancy sleuth -o csv > /go/nancy-report.csv; \
  ls -al /go; \
  ls -al /go/Project1; \
  tar czf project.tgz /go/pkg/mod"

docker cp go:/go/project.tgz ~/Downloads/project.tgz
docker cp go:/go/nancy-report.csv ~/Downloads/nancy-report.csv


sudo chown $USER:$USER project.tgz
sudo chown $USER:$USER nancy-report.csv
sudo chown $USER:$USER ~/Downloads/nancy-report.csv

docker rm go



