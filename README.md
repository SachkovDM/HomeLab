# Kubernetes на Talos через Terraform в Proxmox VE

Этот проект создает Kubernetes кластер на Talos OS с помощью Terraform, который разворачивает виртуальные машины в Proxmox VE.

## Структура проекта

- `providers.tf` - Конфигурация провайдеров Proxmox и Talos
- `variables.tf` - Переменные для настройки инфраструктуры
- `main.tf` - Основная конфигурация для создания ВМ и применения Talos конфигураций
- `talos-config.tf` - Конфигурации машин Talos для control plane и worker нод
- `outputs.tf` - Выходные данные (IP адреса, команды для доступа)
- `terraform.tfvars.example` - Пример файла с переменными

## Требования

- Terraform >= 1.0
- Доступ к Proxmox VE API
- Сетевой доступ между Proxmox и машиной где запускается Terraform
- Созданный шаблон ВМ с Talos OS в Proxmox

## Подготовка

### 1. Создание шаблона Talos в Proxmox

Создайте шаблон ВМ с Talos OS:

```bash
# Скачайте образ Talos
wget https://github.com/siderolabs/talos/releases/download/v1.8.0/talos-amd64-metal.x86_64.iso

# Создайте ВМ в Proxmox и установите Talos
# Преобразуйте ВМ в шаблон
```

### 2. Настройка переменных

Скопируйте пример переменных:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Отредактируйте `terraform.tfvars` с вашими параметрами:

```hcl
proxmox_api_url          = "https://your-proxmox:8006/api2/json"
proxmox_api_token_id     = "your-token-id"
proxmox_api_token_secret = "your-token-secret"
cluster_endpoint         = "192.168.1.100"  # VIP или статический IP
```

### 3. Настройка mTLS для Proxmox

Если ваш Proxmox использует mTLS, создайте директорию `certs/` и поместите туда:

```bash
mkdir certs
# Скопируйте сертификаты в certs/
# - ca.pem (CA сертификат Proxmox)
# - client.pem (клиентский сертификат)  
# - client-key.pem (приватный ключ)
```

Настройте переменные в `terraform.tfvars`:

```hcl
proxmox_tls_insecure = false
proxmox_ca_file      = "./certs/ca.pem"
proxmox_cert_file    = "./certs/client.pem"
proxmox_key_file     = "./certs/client-key.pem"
```

### 4. Создание API токена Proxmox

В Proxmox создайте API токен:
- Datacenter → Permissions → API Tokens
- Add → Token ID: `terraform@pve!token`
- Установите привилегии для нужных ресурсов

## Использование

### Инициализация

```bash
terraform init
```

### Проверка конфигурации

```bash
terraform plan
```

### Создание инфраструктуры

```bash
terraform apply
```

### Получение доступа к кластеру

После создания инфраструктуры:

```bash
# Получить Talos конфигурацию
talosctl config merge <control-plane-ip> -n <control-plane-ip>

# Bootstrap кластера (только на первой control plane ноде)
talosctl bootstrap --nodes <first-control-plane-ip>

# Получить kubeconfig
talosctl kubeconfig -n <control-plane-ip>

# Проверить статус кластера
kubectl get nodes
```

## Управление кластером

### Обновление Talos

```bash
talosctl upgrade --nodes <node-ip> --image ghcr.io/siderolabs/talos:v1.8.0
```

### Просмотр логов

```bash
talosctl logs --nodes <node-ip>
```

### Перезагрузка ноды

```bash
talosctl reboot --nodes <node-ip>
```

## Очистка

```bash
terraform destroy
```

## Структура кластера по умолчанию

- **Control Plane**: 3 ноды (2 CPU, 4GB RAM, 20GB disk)
- **Worker**: 2 ноды (2 CPU, 4GB RAM, 20GB disk)
- **Сеть**: DHCP через мост vmbr0
- **Kubernetes**: Последняя версия с Talos v1.8.0

## Кастомизация

Измените переменные в `terraform.tfvars` для настройки:

- Количество нод (`control_plane_count`, `worker_count`)
- Ресурсы ВМ (`*_cpu`, `*_memory`, `*_disk`)
- Сетевые настройки (`network_bridge`)
- Версию Talos (`talos_version`)
