Vtiger CRM Self-Hosting on Hetzner Cloud
This project provides a complete setup for self-hosting the open-source Vtiger CRM (version 8.3.0) on Hetzner Cloud using Docker Compose, Nginx, and Let’s Encrypt for HTTPS. It includes a custom Dockerfile, Docker Compose configuration, Nginx setup, and an automated setup script.
Features

Deploy Vtiger CRM 8.3.0 with Docker for easy management.
Secure with HTTPS using Let’s Encrypt.
Persistent storage for Vtiger files and MySQL database.
Automated setup script for Hetzner Cloud.
Error handling guide for common issues.
Prepares for future Vicidial integration.

Prerequisites

Hetzner Cloud Account: Server with at least 4 GB RAM, 250 GB disk (e.g., CX22).
Domain: Configured to point to your server’s public IP (e.g., vtiger.dialerportal.com).
SSH Access: Key-based authentication recommended.
DNS: A record set for your domain (e.g., vtiger.dialerportal.com to <server_ip>).

Project Structure
vtiger-self-hosted/
├── Dockerfile
├── docker-compose.yml
├── .env.example
├── nginx/
│   └── vtiger.conf
├── scripts/
│   └── setup.sh
├── README.md
└── errors.txt

Setup Instructions
Step 1: Provision Hetzner Cloud Server

Log in to Hetzner Cloud Console.
Create a server:
Location: Choose a data center (e.g., Nuremberg).
Image: Debian 12.
Type: CX22 or higher (4 GB RAM, 80 GB disk).
Networking: Enable Public IPv4.
SSH Key: Add your SSH key.


Note the server’s public IP (<server_ip>).

Step 2: Configure DNS

Log in to your DNS provider (e.g., Cloudflare, Namecheap).
Add an A record:Type: A
Host: vtiger
Value: <server_ip>
TTL: 300


Verify with:dig vtiger.dialerportal.com



Step 3: Clone the Repository

SSH into your server:ssh root@<server_ip>


Clone the project:git clone https://github.com/yourusername/vtiger-self-hosted.git
cd vtiger-self-hosted



Step 4: Configure Environment

Copy the example environment file:cp .env.example .env


Edit .env:nano .env


Set MYSQL_USER, MYSQL_PASSWORD, and HOST_PORT (default: 8080).
Example:MYSQL_USER=vtiger_user
MYSQL_PASSWORD=YourSecurePassword123
HOST_PORT=8080





Step 5: Run Setup Script

Make the setup script executable:chmod +x scripts/setup.sh


Run the script:./scripts/setup.sh


Updates the system, installs dependencies, starts Vtiger, configures Nginx, and sets up SSL.
Replace your_email@example.com in the script with your email for Certbot.



Step 6: Configure Hetzner Firewall

In Hetzner Cloud Console:
Go to Firewalls > Create Firewall.
Add rules:
TCP 22: SSH.
TCP 80: HTTP (for Certbot).
TCP 443: HTTPS.


Apply to your server.



Step 7: Complete Vtiger Setup

Open https://vtiger.dialerportal.com in your browser.
Follow the Vtiger setup wizard:
System Check: Ensure prerequisites are met.
Database: Uses .env credentials.
Admin User: Set username, password, email.
Settings: Configure timezone, currency.


Log in and test functionality (e.g., create a lead).

Step 8: Post-Installation

Backups: Configured in setup.sh (daily MySQL backups to /var/backups/vtiger).
Security:
Restrict SSH:nano /etc/ssh/sshd_config


Change Port 22 to 2222, then:systemctl restart sshd


Update Hetzner firewall for the new port.




Monitoring:
Install htop:apt install htop -y


Check logs:docker logs vtiger-vtiger-1
tail -f /var/log/nginx/error.log





Expected Errors
See errors.txt for a list of common errors during installation and their solutions.
Future Vicidial Integration
To integrate with Vicidial:

Deploy Vicidial on a separate Hetzner server.
Configure Vtiger’s Phone Calls module with Vicidial as the gateway.
Set Vicidial webforms to send data to Vtiger.
Align user accounts manually.
Allow Vicidial ports in Hetzner firewall (5060 TCP/UDP, 10000-20000 UDP).

Contributing
Contributions are welcome! Please submit a pull request or open an issue on GitHub.
License
This project is licensed under the MIT License.
Contact
For support, open an issue or contact [your email].
