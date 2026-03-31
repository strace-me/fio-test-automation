# FIO Storage Performance Testing Automation

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Автоматизация нагрузочного тестирования систем хранения данных (СХД) с использованием Ansible и Jenkins.

## 📋 Оглавление

- [Архитектура](#архитектура)
- [Требования](#требования)
- [Быстрый старт](#быстрый-старт)
- [Использование](#использование)
- [Структура проекта](#структура-проекта)
- [Лицензия](#лицензия)

## 🏗️ Архитектура
┌─────────────────────────────────────────────────────────────────┐
│ Jenkins (10.2.2.242) │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ lun-manager pipeline │ fio-test pipeline │ │
│ └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────────────┐
│ Ansible Controller (10.2.2.241) │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ Playbooks: fio_test.yml, setup_luns.yml, reset_luns.yml│ │
│ └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
│
┌─────────────────────┼─────────────────────┐
▼ ▼ ▼
┌───────────────┐ ┌───────────────┐ ┌───────────────┐
│ fio-client-1 │ │ fio-client-2 │ │ fio-client-N │
└───────────────┘ └───────────────┘ └───────────────┘
│
▼
┌───────────────────┐
│ Storage │
│ Array │
└───────────────────┘

text

## 📦 Требования

### Аппаратные требования
- 1 VM для Ansible Controller (2 CPU, 4 GB RAM, 40 GB disk)
- 1 VM для Jenkins (2 CPU, 8 GB RAM, 80 GB disk)
- N VM для fio-клиентов (2 CPU, 4 GB RAM, 40 GB disk each)
- СХД с iSCSI поддержкой

### Программные требования
- Ubuntu 22.04/24.04 LTS
- Ansible 2.15+
- Jenkins 2.440+
- Python 3.10+

## 🚀 Быстрый старт

### 1. Клонирование репозитория

```bash
git clone https://github.com/strace-me/fio-test-automation.git
cd fio-test-automation
2. Настройка конфигурации
bash
cp inventory/vars.env.example inventory/vars.env
vim inventory/vars.env
Заполните ваши IP-адреса и IQN:

bash
export STORAGE_IP="10.20.3.23"
export CLIENT1_IP="10.2.2.243"
export CLIENT1_IQN="iqn.2014-05.com.raidix:target.684698"
# ... и так далее
3. Генерация inventory
bash
./scripts/generate_inventory.sh
4. Установка Ansible
bash
sudo apt update
sudo apt install -y ansible git python3-pip sshpass
ansible-galaxy collection install community.general
5. Генерация SSH ключей
bash
mkdir -p ssh-keys
ssh-keygen -t rsa -b 4096 -f ssh-keys/id_rsa -N ""
6. Распространение ключей
bash
ansible-playbook -i inventory/hosts.ini playbooks/distribute_ssh_keys.yml --ask-pass
7. Подготовка LUN
bash
ansible-playbook -i inventory/hosts.ini playbooks/setup_luns.yml \
    -e "target_hosts=all_fio" \
    -e "force_format=true" \
    -e "create_test_file=true"
8. Запуск тестов
bash
ansible-playbook -i inventory/hosts.ini playbooks/fio_test.yml \
    -e "target_hosts=all_fio" \
    -e "test_type=randread" \
    -e "block_size=4k" \
    -e "runtime=30"
📊 Результаты тестов
text
╔════════════════════════════════════════════════════════════════════════════════╗
║                         F I O   T E S T   R E S U L T S                        ║
╠════════════════════════════════════════════════════════════════════════════════╣
║ Build: #11                                                                     ║
║ Test: randread | BS: 4k | Runtime: 30s                                         ║
║ I/O Depth: 128 | Jobs: 4 | Direct I/O: true                                    ║
╠════════════════════════════════════════════════════════════════════════════════╣
║  Client               │         IOPS │     MB/s │                     ║
║───────────────────────┼──────────────┼──────────┼─────────────────────║
║  fio-ubuntu-1x1       │        40236 │      157 │                     ║
║  fio-ubuntu-1x2       │        39511 │      154 │                     ║
║  fio-ubuntu-2x1       │        37542 │      147 │                     ║
║  fio-ubuntu-2x2       │        39900 │      156 │                     ║
║───────────────────────┼──────────────┼──────────┼─────────────────────║
║  TOTAL                │       157189 │      614 │  TOTAL               ║
╚════════════════════════════════════════════════════════════════════════════════╝
🔧 Компоненты
Файл	Назначение
playbooks/setup_luns.yml	Подключение и форматирование LUN
playbooks/reset_luns.yml	Сброс LUN
playbooks/fio_test.yml	Запуск тестов производительности
scripts/generate_inventory.sh	Генерация inventory из шаблона
scripts/first_deploy.sh	Интерактивный скрипт первого развертывания
jenkins/Jenkinsfile-fio-test	Jenkins Pipeline для тестов
🔒 Безопасность
Все чувствительные данные НЕ хранятся в репозитории:

IP-адреса

IQN

Пароли

Для хранения секретов используйте:

inventory/vars.env (не коммитится)

Ansible Vault (опционально)

Jenkins Credentials

📝 Лицензия
MIT License. См. файл LICENSE.

👤 Автор
strace-me

