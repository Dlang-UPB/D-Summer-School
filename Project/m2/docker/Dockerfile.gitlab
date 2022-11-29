FROM ubuntu:latest

ENV LDC=ldc-1.30.0

ENV DEBIAN_FRONTEND="noninteractive"

WORKDIR /checker

RUN apt-get update

RUN apt-get install -y build-essential

RUN apt-get install -y libevent-dev libssl-dev libxml2 lzma-dev

RUN apt-get install -y wget curl xz-utils

RUN ["/bin/bash", "-c", "curl -fsS https://dlang.org/install.sh | bash -s $LDC"]

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait
