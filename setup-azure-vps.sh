#!/usr/bin/env bash
set -e

echo "=== 1. TẠO 8GB SWAP (RAM ẢO) CHO VPS 4GB ==="
if [ ! -f /swapfile ]; then
    echo "Đang cấp phát 8GB Swap..."
    sudo fallocate -l 8G /swapfile || sudo dd if=/dev/zero of=/swapfile bs=1M count=8192
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    sudo sysctl vm.swappiness=20
    echo 'vm.swappiness=20' | sudo tee -a /etc/sysctl.conf
    echo "Tạo Swap thành công!"
else
    echo "Swapfile đã tồn tại, bỏ qua bước này."
fi

echo "=== 2. KIỂM TRA BỘ NHỚ ==="
free -h

echo "=== 3. CÀI ĐẶT DOCKER & DOCKER COMPOSE (NẾU CHƯA CÓ) ==="
if ! command -v docker &> /dev/null; then
    echo "Docker chưa có, tiến hành cài đặt..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo "Cài Docker hoàn tất!"
fi

echo "=== 4. SẴN SÀNG CHẠY HỆ THỐNG ==="
echo "Để khởi động toàn bộ hệ thống tối ưu:"
echo "  docker compose -f docker-compose.prod.yml up -d"
