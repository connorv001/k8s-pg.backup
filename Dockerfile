FROM mdillon/postgis:9.6
RUN apt update -y
RUN apt install -y awscli mcrypt
COPY do_backup.sh /
RUN chmod +x do_backup.sh
