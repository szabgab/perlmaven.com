FROM ubuntu:18.04
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y libimage-magick-perl

# install modules that are needed

WORKDIR /opt
COPY bin/script.pl /opt/script.pl

ENTRYPOINT ["perl", "script.pl"]

