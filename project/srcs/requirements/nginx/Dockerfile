FROM debian:latest

RUN apt update -y && apt upgrade -y && \
    apt install -y nginx openssl && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Generate SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/ftapponn.42.crt \
    -out /etc/nginx/ssl/ftapponn.42.key \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=ftapponn.42.fr"

RUN chmod 644 /etc/nginx/ssl/ftapponn.42.crt /etc/nginx/ssl/ftapponn.42.key

# Copy Nginx configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
