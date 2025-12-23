#!/bin/bash

# Script untuk deploy ke cPanel public_html
# Usage: ./deploy.sh

# Warna untuk output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Memuat konfigurasi
if [ -f "deploy.conf" ]; then
    source deploy.conf
else
    echo -e "${RED}Error: File deploy.conf tidak ditemukan!${NC}"
    echo "Silakan copy deploy.conf.example ke deploy.conf dan isi konfigurasinya."
    exit 1
fi

echo -e "${YELLOW}=== Deployment ke cPanel ===${NC}"
echo "Server: $CPANEL_HOST"
echo "User: $CPANEL_USER"
echo "Remote Path: $REMOTE_PATH"
echo ""

# Validasi konfigurasi
if [ -z "$CPANEL_HOST" ] || [ -z "$CPANEL_USER" ] || [ -z "$REMOTE_PATH" ]; then
    echo -e "${RED}Error: Konfigurasi tidak lengkap!${NC}"
    exit 1
fi

# Pastikan file sudah di-commit ke git
echo -e "${YELLOW}Memeriksa status Git...${NC}"
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}Warning: Ada perubahan yang belum di-commit${NC}"
    read -p "Lanjutkan deployment? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Deploy menggunakan rsync
echo -e "${YELLOW}Memulai deployment...${NC}"

# Opsi rsync
RSYNC_OPTIONS="-avz --delete --exclude='.git' --exclude='deploy.sh' --exclude='deploy.conf' --exclude='deploy.conf.example' --exclude='README.md'"

# Jika menggunakan port kustom
if [ -n "$SSH_PORT" ]; then
    RSYNC_OPTIONS="$RSYNC_OPTIONS -e 'ssh -p $SSH_PORT'"
fi

# Eksekusi rsync
rsync_cmd="rsync $RSYNC_OPTIONS ./ $CPANEL_USER@$CPANEL_HOST:$REMOTE_PATH"
echo -e "${YELLOW}Menjalankan: $rsync_cmd${NC}"
eval $rsync_cmd

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Deployment berhasil!${NC}"
else
    echo -e "${RED}✗ Deployment gagal!${NC}"
    exit 1
fi

