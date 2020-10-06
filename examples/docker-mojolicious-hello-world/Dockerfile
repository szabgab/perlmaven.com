FROM perl:5.32
RUN cpanm Mojolicious
WORKDIR /opt
COPY demo.pl .
CMD ["perl", "demo.pl", "daemon"]

