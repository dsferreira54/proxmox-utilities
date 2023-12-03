#!/bin/bash

# Creating init-proxmox-template shell script
cat <<EOF > /usr/local/bin/init-proxmox-template
#!/bin/bash

# Remove SSH keys
echo "Removing SSH keys..."
rm -f /etc/ssh/ssh_host_*

# Generate new SSH keys
echo "Generating new SSH keys..."
dpkg-reconfigure openssh-server

# Reset the machine-id
echo "Resetting the machine-id..."
echo -n > /etc/machine-id

# Generate a new machine-id
echo "Generating a new machine-id..."
systemd-machine-id-setup

# Disabling init-proxmox-template.service
echo "Disabling init-proxmox-template.service..."
systemctl disable init-proxmox-template.service

echo "Process completed!"
EOF

chmod +x /usr/local/bin/init-proxmox-template

# Creating init-proxmox-template.service system service
cat <<EOF > /etc/systemd/system/init-proxmox-template.service
[Unit]
Description=Init Promox Template
After=network.target

[Service]
ExecStart=/usr/local/bin/init-proxmox-template

[Install]
WantedBy=default.target
EOF

# Enabling init-proxmox-template.service
sudo systemctl daemon-reload
systemctl enable init-proxmox-template.service
