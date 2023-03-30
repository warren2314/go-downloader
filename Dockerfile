FROM golang:1.17-buster

RUN apt-get update && \
    apt-get install git

RUN git clone https://github.com/sonatype-nexus-community/nancy.git

RUN cd nancy/ && \
    go get ./... && \
    go build -o nancy .

RUN mkdir Project1

WORKDIR /go/Project1

RUN go mod init example.com/1

ENV GO_VERSION=1.16

RUN sed -i "s/go [[:digit:]]\+\(\.[[:digit:]]\+\)*/go ${GO_VERSION}/g" /go/Project1/go.mod

COPY entrypoint.sh /entrypoint.sh
COPY process_modules.sh /go/process_modules.sh

RUN chmod +x /entrypoint.sh
RUN chmod +x /go/process_modules.sh

ENTRYPOINT ["/entrypoint.sh"]

