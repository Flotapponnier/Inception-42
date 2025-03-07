FROM debian:latest

RUN apt update && apt upgrade -y && \
    apt install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/ftapponn.42.fr.key \
    -out /etc/nginx/ssl/ftapponn.42.fr.crt \
    -subj "/CN=ftapponn.42.fr"

# Copy the configuration file
COPY default /etc/nginx/sites-available/default

# Expose both HTTP and HTTPS ports
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

