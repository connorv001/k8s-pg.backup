FROM mdillon/postgis:9.6
RUN apt update -y
RUN apt install -y awscli mcrypt
COPY backup.sh /
RUN chmod +x backup.sh
