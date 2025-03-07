FROM debian:latest

RUN apt-get -y update && apt-get upgrade -y

RUN apt-get install -y mariadb-server

COPY ./conf/maria-script.sh /maria-script.sh

RUN chmod +x /maria-script.sh

ENTRYPOINT ["./maria-script.sh"]
