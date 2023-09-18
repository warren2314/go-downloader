#!/bin/sh -i

sh /go/process_modules.sh

cd /go/Project1
echo "Starting Nancy Report Generation..." >> go/nancy.log
go list --json -m all | /go/Project1/nancy sleuth -o csv > /go/nancy-report.csv
echo "Nancy Report Generation Completed." >> /go/nancy.log
tar czf /go/project.tgz /go/pkg/mod

# Define the target directory
target_dir="/downloads"

# Copy the files to the mounted volume
cp /go/project.tgz $target_dir/project.tgz
cp /go/nancy-report.csv $target_dir/nancy-report.csv

# Change ownership of the copied files
chown $(stat -c '%u:%g' $target_dir) $target_dir/project.tgz
chown $(stat -c '%u:%g' $target_dir) $target_dir/nancy-report.csv

exec "$@"

