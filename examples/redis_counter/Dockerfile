FROM perl:5.32

WORKDIR /opt
COPY cpanfile /opt/
RUN cpanm --installdeps --notest .


CMD  ["plackup", "--host", "0.0.0.0", "--port", "5000"]

