FROM golang:alpine

# Install Git and Vim
RUN apk update && \
    apk add git

# Check which directory you are in
#RUN pwd

# Clone the Nancy repository
RUN git clone https://github.com/sonatype-nexus-community/nancy.git 

# Install Go dependencies and build the application
RUN cd nancy/ && \
    go get ./... && \
    go build -o nancy .

RUN cd ..

# Create a new directory for the project
RUN mkdir Project1
WORKDIR /go/Project1

ARG PACKAGE_TO_DOWNLOAD

# Get user input for the package name and version
RUN go mod init example.com/1 && \
    go get ${PACKAGE_TO_DOWNLOAD}

# Check against Nancy for vulnerabilities
RUN go list --json -m all | ../nancy/nancy sleuth -o csv > nancy-report.csv

# Change the Go version to 1.16
RUN sed -i 's/go 1.18/go 1.16/g' /go/Project1/go.mod

# Delete the Go package cache
RUN rm -rf /go/pkg/*

# Download all the required packages
RUN pwd && cd /go/Project1 && \
    go mod download

# Package the project and copy to /downloads
RUN cp nancy-report.csv /go/

# Show working Directory
#RUN ls -la

# Zip the files 
WORKDIR /go/
RUN tar -czvf project.tgz pkg/ 

#check the files
RUN ls -la

# Set the entrypoint to a shell script that copies the packaged project to the host machine
COPY start.sh /go/start.sh
RUN chmod +x /go/start.sh

# Define a shared volume
VOLUME /output

ENTRYPOINT ["sh", "/go/start.sh"]
