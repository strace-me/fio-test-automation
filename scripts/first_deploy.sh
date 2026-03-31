#!/bin/bash
# First deployment script
# Interactive setup of infrastructure variables

#!/bin/bash
set -e

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║     First Deployment - Enter your infrastructure details     ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

read -p "Storage IP: " STORAGE_IP
read -p "Secondary Storage IP: " STORAGE_IP_SECONDARY
read -p "Jenkins IP: " JENKINS_IP
read -p "Client 1 IP (fio-ubuntu-1x1): " CLIENT1_IP
read -p "Client 1 IQN: " CLIENT1_IQN
read -p "Client 2 IP (fio-ubuntu-1x2): " CLIENT2_IP
read -p "Client 2 IQN: " CLIENT2_IQN
read -p "Client 3 IP (fio-ubuntu-2x1): " CLIENT3_IP
read -p "Client 3 IQN: " CLIENT3_IQN
read -p "Client 4 IP (fio-ubuntu-2x2): " CLIENT4_IP
read -p "Client 4 IQN: " CLIENT4_IQN

cat > inventory/vars.env << EOF
export STORAGE_IP="$STORAGE_IP"
export STORAGE_IP_SECONDARY="$STORAGE_IP_SECONDARY"
export JENKINS_IP="$JENKINS_IP"
export CLIENT1_IP="$CLIENT1_IP"
export CLIENT1_IQN="$CLIENT1_IQN"
export CLIENT2_IP="$CLIENT2_IP"
export CLIENT2_IQN="$CLIENT2_IQN"
export CLIENT3_IP="$CLIENT3_IP"
export CLIENT3_IQN="$CLIENT3_IQN"
export CLIENT4_IP="$CLIENT4_IP"
export CLIENT4_IQN="$CLIENT4_IQN"
EOF

./scripts/generate_inventory.sh

echo ""
echo "✅ Configuration saved!"
echo ""
echo "Next steps:"
echo "  1. Generate SSH keys: ssh-keygen -t rsa -f ssh-keys/id_rsa -N ''"
echo "  2. Distribute keys: ansible-playbook -i inventory/hosts.ini playbooks/distribute_ssh_keys.yml --ask-pass"
echo "  3. Setup LUNs: ansible-playbook -i inventory/hosts.ini playbooks/setup_luns.yml -e 'target_hosts=all_fio'"