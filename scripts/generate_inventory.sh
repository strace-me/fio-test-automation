#!/bin/bash
# Generate inventory from template
# This script creates inventory/hosts.ini from inventory/vars.env

#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

if [ ! -f inventory/vars.env ]; then
    echo "ERROR: inventory/vars.env not found!"
    echo "Please copy inventory/vars.env.example to inventory/vars.env and edit"
    exit 1
fi

source inventory/vars.env
envsubst < inventory/hosts.ini.template > inventory/hosts.ini

echo "✅ Inventory generated: inventory/hosts.ini"
echo "⚠️  DO NOT commit this file to git!"
