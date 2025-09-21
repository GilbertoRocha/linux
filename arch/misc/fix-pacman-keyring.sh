#!/bin/bash
set -e

echo "🔑 Corrigindo keyring e configurando mirrors rápidos..."

# 1. Atualizar base de pacotes
sudo pacman -Sy --noconfirm

# 2. Instalar/atualizar o keyring do Arch
sudo pacman -S --noconfirm archlinux-keyring

# 3. Inicializar e popular o keyring
sudo pacman-key --init
sudo pacman-key --populate archlinux

# 4. Atualizar chaves a partir de um servidor confiável
sudo pacman-key --keyserver hkps://keyserver.ubuntu.com --refresh-keys || true

# 5. Instalar reflector para otimizar mirrors
sudo pacman -S --noconfirm reflector

# 6. Gerar lista de mirrors do Brasil, ordenados por velocidade
sudo reflector --country Brazil --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# 7. Atualizar todo o sistema
sudo pacman -Syu --noconfirm

echo "✅ Keyring corrigido, mirrors otimizados e sistema atualizado!"

