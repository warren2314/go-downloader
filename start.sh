#!/bin/bash

# Download the specified Go Module with the version
go get $GO_MODULE@$GO_VERSION

# Move this to the go.mod file
go mod edit -replace $GO_MODULE=$GO_MODULE@$GO_VERSION

# Check against Nancy for vulnerabilities
go list -m all | ../nancy/nancy sleuth --csv > /go/nancy-report.csv

cp /go/project.tgz /output/
cp /go/nancy-report.csv /output/

# Exit the container
exit 0

