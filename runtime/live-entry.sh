#!/bin/sh

mkdir Project1

cd /go/Project1
go mod init example.com/1

#Go Version should be provided with an env
#GO_VERSION=1.21

sed -i "s/go [[:digit:]]\+\(\.[[:digit:]]\+\)*/go ${GO_VERSION}/g" /go/Project1/go.mod

#entrypoint.sh /entrypoint.sh
#process_modules.sh /go/process_modules.sh

#sh /go/process_modules.sh
cd /go/Project1
go clean -modcache

go get $GO_MODULE_DOWNLOAD

#go list --json -m all | /go/Project1/nancy sleuth -o csv > /go/nancy-report.csv
go list --json -m all > /temp/downloads/packages.json

# Remove the sumdb directory
rm -rf /go/pkg/mod/cache/download/sumdb

# Archive the downloads directory
tar czf /go/project.tgz /go/pkg/mod/cache/download

# Define the target directory
target_dir="/temp/downloads"

# Copy the files to the mounted volume
cp /go/project.tgz $target_dir/project.tgz
#cp /go/nancy-report.csv $target_dir/nancy-report.csv

# Change ownership of the copied files
chown $(stat -c '%u:%g' $target_dir) $target_dir/project.tgz
#chown $(stat -c '%u:%g' $target_dir) $target_dir/nancy-report.csv

#exec "$@"
