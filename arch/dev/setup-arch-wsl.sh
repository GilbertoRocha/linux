#!/bin/bash
set -e

echo "🚀 Iniciando configuração completa do Arch Linux no WSL2..."

# =========================
# 1. Corrigir Keyring
# =========================
echo "🔑 Atualizando keyring..."
pacman -Sy --noconfirm
pacman -S --noconfirm archlinux-keyring
pacman-key --init
pacman-key --populate archlinux
pacman-key --keyserver hkps://keyserver.ubuntu.com --refresh-keys || true

# =========================
# 2. Otimizar mirrors para o Brasil
# =========================
echo "🌎 Configurando mirrors rápidos..."
pacman -S --noconfirm reflector
reflector --country Brazil --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# =========================
# 3. Atualizar sistema
# =========================
echo "📦 Atualizando sistema..."
pacman -Syu --noconfirm

# =========================
# 4. Instalar pacotes essenciais
# =========================
echo "🛠 Instalando pacotes essenciais..."
pacman -S --noconfirm git zsh curl wget vim base-devel

# =========================
# 5. Instalar Oh My Zsh
# =========================
echo "🎨 Instalando Oh My Zsh..."
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# =========================
# 6. Instalar Powerlevel10k
# =========================
echo "💎 Instalando Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# =========================
# 7. Instalar plugins Zsh
# =========================
echo "🔌 Instalando plugins Zsh..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# =========================
# 8. Criar usuário normal
# =========================
read -p "👤 Nome do novo usuário para desenvolvimento: " DEVUSER
useradd -m -G wheel -s /bin/zsh "$DEVUSER"
passwd "$DEVUSER"

# Dar permissão de sudo
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# =========================
# 9. Configurar Zsh para o novo usuário
# =========================
USER_HOME="/home/$DEVUSER"

# Criar .zshrc otimizado
cat > "$USER_HOME/.zshrc" <<'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting colored-man-pages sudo)
source $ZSH/oh-my-zsh.sh

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY

autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -u

setopt CORRECT
autoload -U colors && colors
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias ll='ls -lh --color=auto'
alias la='ls -lha --color=auto'
alias gs='git status'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias ..='cd ..'
alias ...='cd ../..'
alias open='explorer.exe .'
alias clip='clip.exe'

export EDITOR=vim
export LANG=pt_BR.UTF-8
export LC_ALL=pt_BR.UTF-8

echo -e "\n🚀 Zsh carregado com sucesso! Bom trabalho."
EOF

# Criar .p10k.zsh minimalista
cat > "$USER_HOME/.p10k.zsh" <<'EOF'
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{blue}╭─%f"
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{blue}╰%f "
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs prompt_char)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time)
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
typeset -g POWERLEVEL9K_DIR_FOREGROUND=4
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=2
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=3
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=1
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=2
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=1
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=3
typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'
typeset -g POWERLEVEL9K_TIME_FOREGROUND=8
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS='%F{green}❯%f'
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS='%F{red}❯%f'
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD='%F{green}❮%f'
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD='%F{red}❮%f'
typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
EOF

# Ajustar permissões
chown "$DEVUSER:$DEVUSER" "$USER_HOME/.zshrc" "$USER_HOME/.p10k.zsh"

# =========================
# 10. Definir usuário padrão no WSL
# =========================
echo "[user]" > /etc/wsl.conf
echo "default=$DEVUSER" >> /etc/wsl.conf

# =========================
# 11. Mensagem final
# =========================
echo "✅ Configuração concluída!"
echo "Feche e reabra o WSL para entrar como $DEVUSER com Zsh e Powerlevel10k prontos."

