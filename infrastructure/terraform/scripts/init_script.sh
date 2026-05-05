#!/bin/bash
set -eux
exec > /var/log/init_script.log 2>&1

echo "=== Starting init script $(date) ==="

# Configure swap — 4GB, persistent across reboots
SWAP_FILE=/swapfile
SWAP_SIZE=4G

fallocate -l $SWAP_SIZE $SWAP_FILE
chmod 600 $SWAP_FILE
mkswap $SWAP_FILE
swapon $SWAP_FILE
echo "${SWAP_FILE} none swap sw 0 0" >> /etc/fstab

# Reduce swap aggressiveness — only use swap under memory pressure
echo "vm.swappiness=10" >> /etc/sysctl.conf
# Improve cache pressure so the kernel keeps file system cache longer
echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf
sysctl -p

echo "Swap configured: $(swapon --show)"

apt-get update -y
apt-get install -y ca-certificates curl gnupg

# Install Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

ARCH=$(dpkg --print-architecture)
CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME")

echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${CODENAME} stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker

# Install Java (required by Jenkins)
apt-get install -y fontconfig openjdk-21-jre

# Install Jenkins
wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

apt-get update -y
apt-get install -y jenkins

systemctl enable jenkins
systemctl start jenkins

# Allow Jenkins to run Docker commands
# Restart required so Jenkins picks up the new group membership
usermod -aG docker jenkins
systemctl restart jenkins

echo "=== Init script complete $(date) ==="
