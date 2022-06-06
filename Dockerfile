FROM bitnami/postgresql:14-debian-11
RUN apt update -y
RUN apt install -y awscli mcrypt
COPY do_backup.sh /
RUN chmod +x do_backup.sh
CMD "do_backup.sh"
