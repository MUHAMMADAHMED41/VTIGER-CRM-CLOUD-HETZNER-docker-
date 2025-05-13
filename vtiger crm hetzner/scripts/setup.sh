#!/bin/bash
# Setup script for Vtiger CRM on Hetzner Cloud

# Exit on error
set -e

# Update system
apt update && apt upgrade -y

# Install dependencies
apt install -y docker.io nginx python3-certbot-nginx ufw apparmor

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Enable and start Docker
systemctl enable docker
systemctl start docker

# Create project directory
mkdir -p /root/vtiger
cd /root/vtiger

# Copy .env.example to .env
if [ ! -f .env ]; then
    cp .env.example .env
    echo "Please edit /root/vtiger/.env with your desired credentials."
fi

# Start containers
docker-compose up -d

# Configure Nginx
mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled
cp nginx/vtiger.conf /etc/nginx/sites-available/vtiger
ln -s /etc/nginx/sites-available/vtiger /etc/nginx/sites-enabled/vtiger
mkdir -p /var/www/html/.well-known/acme-challenge
chown -R www-data:www-data /var/www/html
nginx -t
systemctl restart nginx

# Obtain SSL certificate
certbot --nginx -d vtiger.dialerportal.com --non-interactive --agree-tos --email your_email@example.com --redirect

# Configure UFW
ufw allow 22
ufw allow 80
ufw allow 443
ufw enable

# Set up backups
mkdir -p /var/backups/vtiger
chown www-data:www-data /var/backups/vtiger
echo "0 2 * * * docker run --rm -v vtiger_mysql_data_volume:/volume -v /var/backups/vtiger:/backup alpine tar cvf /backup/mysql-$(date +%F).tar /volume" | crontab -

echo "Vtiger CRM is running at https://vtiger.dialerportal.com"
echo "Configure Hetzner Cloud Firewall to allow ports 22, 80, 443."
echo "Complete the Vtiger setup wizard in your browser."