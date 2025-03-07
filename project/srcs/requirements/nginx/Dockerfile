FROM debian:latest

RUN apt update && apt upgrade -y && \
    apt install -y nginx openssl

# Create directory for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Generate self-signed certificate (for testing)
# In production, you should use proper certificates
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/ftapponn.42.fr.key \
    -out /etc/nginx/ssl/ftapponn.42.fr.crt \
    -subj "/CN=ftapponn.42.fr"

# Copy the configuration file
COPY nginx.conf /etc/nginx/sites-available/default

# Expose both HTTP and HTTPS ports
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

