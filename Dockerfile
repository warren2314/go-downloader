FROM golang:alpine
RUN apk update && \
    apk add git
RUN git clone https://github.com/sonatype-nexus-community/nancy.git
RUN cd nancy/ && \
    go get ./... && \
    go build -o nancy .
RUN mkdir Project1
WORKDIR /go/Project1
RUN go mod init example.com/1
ENV GO_VERSION=1.16
RUN sed -i "s/go [[:digit:]]\+\(\.[[:digit:]]\+\)*/go ${GO_VERSION}/g" /go/Project1/go.mod
RUN ls -al
COPY fetch_go_files.sh /go/fetch_go_files.sh
RUN ls -al /go
RUN chmod +x /go/fetch_go_files.sh
RUN cd /go/Project1 && \
    go mod download
WORKDIR /go/
RUN tar -czvf project.tgz pkg/
COPY start.sh /go/start.sh
RUN chmod +x /go/start.sh
COPY entrypoint.sh /go/entrypoint.sh
RUN chmod +x /go/entrypoint.sh
ENTRYPOINT ["/go/entrypoint.sh"]
CMD ["/bin/sh", "-c", "/go/fetch_go_files.sh && /go/start.sh"]



