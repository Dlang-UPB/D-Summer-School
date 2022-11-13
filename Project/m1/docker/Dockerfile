FROM ubuntu:latest

ENV DMD=dmd-2.100.2

ENV DEBIAN_FRONTEND="noninteractive"

WORKDIR /checker

COPY ./db_conn /checker

RUN apt-get update

RUN apt-get install -y build-essential

RUN apt-get install -y libevent-dev libssl-dev

RUN apt-get install -y wget curl xz-utils

RUN ["/bin/bash", "-c", "curl -fsS https://dlang.org/install.sh | bash -s $DMD"]

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait

#RUN ["/bin/bash", "-c", "cd /checker && source ~/dlang/$DMD/activate && dub build"]

# Wait for the mongo instance to be up and running
#RUN WAIT_HOSTS=localhost:27017 ./wait &&\
    #cd m1/db_conn &&\
    #source ~/dlang/$DMD/activate &&\
    #dub run

#COPY ./checker ${CHECKER_DATA_DIRECTORY}
