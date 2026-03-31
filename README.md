# FIO Storage Performance Testing Automation

Автоматизация нагрузочного тестирования систем хранения данных (СХД) с использованием Ansible и Jenkins.

## Быстрый старт

```bash
git clone https://github.com/YOUR_USERNAME/fio-test-automation.git
cd fio-test-automation
cp inventory/vars.env.example inventory/vars.env
vim inventory/vars.env  # Fill your IPs and IQN
./scripts/generate_inventory.sh
./scripts/first_deploy.sh
```
Требования
Ubuntu 22.04/24.04 LTS

Ansible 2.15+

Python 3.10+

Лицензия
MIT
