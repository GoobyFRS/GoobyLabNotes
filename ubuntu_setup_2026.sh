#!/bin/bash
USERNAME="matt"
LIBRENMS_IP="100.95.216.49"
SNMP_COMMUNITY="librenms"

# ---------------------------------------------------------------------------
# Step 1 — Update package lists and upgrade installed packages
# ---------------------------------------------------------------------------
echo "Step 1 of 7 started."
echo "Fetching updates and applying upgrades. This may take a moment."
sudo apt update && sudo apt upgrade -y || { echo "Failed to update and upgrade packages."; exit 1; }
echo "Step 1 of 7 completed successfully."

# ---------------------------------------------------------------------------
# Step 2 — Install utility packages
# ---------------------------------------------------------------------------
echo "Step 2 of 7 started."
echo "Installing packages: python3-full, pydf, git, curl, wget, whois, crowdsec, fail2ban."
sudo apt install -y python3-full pydf git curl wget whois crowdsec fail2ban || { echo "Failed to install packages."; exit 1; }
echo "Step 2 of 7 completed successfully."

# ---------------------------------------------------------------------------
# Step 3 — Set timezone
# ---------------------------------------------------------------------------
echo "Step 3 of 7 started."
echo "Checking default Timezone."
date
echo "Setting Timezone to PST."
sudo timedatectl set-timezone America/Los_Angeles || { echo "Failed to set timezone."; exit 1; }
echo "Updated Timezone:"
date
echo "Step 3 of 7 completed successfully."

# ---------------------------------------------------------------------------
# Step 4 — Create user account
# ---------------------------------------------------------------------------
echo "Step 4 of 7 started."
echo "Creating user account: $USERNAME"
sudo useradd -m -G sudo -s /bin/bash "$USERNAME" || { echo "Failed to create user $USERNAME."; exit 1; }
echo "Account for $USERNAME created successfully."
echo "Step 4 of 7 completed successfully."

# ---------------------------------------------------------------------------
# Step 5 — Configure Fail2Ban
# ---------------------------------------------------------------------------
echo "Step 5 of 7 started."
echo "Configuring Fail2Ban."
sudo cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local || { echo "Failed to copy Fail2Ban configuration."; exit 1; }
sudo systemctl enable fail2ban.service
sudo systemctl start fail2ban.service
sudo systemctl status fail2ban.service --no-pager || { echo "Fail2Ban service failed to start."; exit 1; }
echo "Fail2Ban enabled and running."
echo "Step 5 of 7 completed successfully."

# ---------------------------------------------------------------------------
# Step 6 — Enable unattended-upgrades
# ---------------------------------------------------------------------------
echo "Step 6 of 7 started."
echo "Installing and configuring unattended-upgrades."
sudo apt install -y unattended-upgrades apt-listchanges || { echo "Failed to install unattended-upgrades."; exit 1; }

# Enable automatic security updates
sudo dpkg-reconfigure -f noninteractive unattended-upgrades || { echo "Failed to configure unattended-upgrades."; exit 1; }

# Ensure the service is enabled and running
sudo systemctl enable unattended-upgrades.service
sudo systemctl start unattended-upgrades.service
sudo systemctl status unattended-upgrades.service --no-pager || { echo "unattended-upgrades service failed to start."; exit 1; }

echo "unattended-upgrades enabled and running."
echo "Step 6 of 7 completed successfully."

# ---------------------------------------------------------------------------
# Step 7 — Install and configure SNMP for LibreNMS polling
# ---------------------------------------------------------------------------
echo "Step 7 of 7 started."
echo "Installing snmpd and configuring for LibreNMS polling."

sudo apt install -y snmpd libsnmp-dev || { echo "Failed to install snmpd."; exit 1; }

# Back up the default config before overwriting
sudo cp /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.bak || { echo "Failed to back up snmpd.conf."; exit 1; }

# Write a clean LibreNMS-compatible snmpd.conf
# - Binds on all interfaces (adjust to 127.0.0.1 if you want localhost-only)
# - Restricts read access to the LibreNMS poller IP via the Tailscale address
# - Exposes standard OID trees expected by LibreNMS
sudo tee /etc/snmp/snmpd.conf > /dev/null <<EOF
# snmpd.conf — managed by setup.sh, generated for LibreNMS polling
# Back up at /etc/snmp/snmpd.conf.bak

agentAddress udp:161

# Allow the LibreNMS poller to read with the configured community string
rocommunity ${SNMP_COMMUNITY} ${LIBRENMS_IP}

# System information
sysLocation    Default Location
sysContact     GoobyFRS
sysServices    72

# Expose full MIB tree (required by LibreNMS)
view   systemonly  included   .1.3.6.1.2.1.1
view   systemonly  included   .1.3.6.1.2.1.25.1

# Enable common extend scripts used by LibreNMS
extend .1.3.6.1.4.1.2021.7890.1 distro /usr/bin/distro
EOF

# Download the LibreNMS distro detection script if not already present
if [ ! -f /usr/bin/distro ]; then
    sudo curl -fsSL https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/distro \
        -o /usr/bin/distro || { echo "Failed to download LibreNMS distro script."; exit 1; }
    sudo chmod +x /usr/bin/distro
    echo "LibreNMS distro detection script installed."
fi

sudo systemctl enable snmpd.service
sudo systemctl restart snmpd.service
sudo systemctl status snmpd.service --no-pager || { echo "snmpd failed to start."; exit 1; }

echo "snmpd enabled and running. LibreNMS can poll this host at UDP/161."
echo "Step 7 of 7 completed successfully."

# ---------------------------------------------------------------------------
# Final message
# ---------------------------------------------------------------------------
echo ""
echo "=========================================="
echo " Basic system setup complete."
echo " CrowdSec and Fail2Ban are operational."
echo " Unattended security upgrades are active."
echo " SNMP is listening for LibreNMS on UDP/161."
echo " Poller allowed: ${LIBRENMS_IP}"
echo " Community:      ${SNMP_COMMUNITY}"
echo "=========================================="
