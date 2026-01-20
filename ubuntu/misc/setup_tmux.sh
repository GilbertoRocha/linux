cat << 'EOF' > setup_tmux.sh
#!/bin/bash

echo "Instalando Tmux..."
sudo apt update && sudo apt install tmux -y

echo "Configurando o arquivo ~/.tmux.conf..."

cat << 'EOC' > ~/.tmux.conf
# --- CONFIGURAÇÃO DE NAVEGAÇÃO RÁPIDA ---

# Iniciar janelas e painéis em 1 (mais fácil para o teclado)
set -g base-index 1
setw -g pane-base-index 1

# Habilitar suporte ao mouse (clicar em abas, redimensionar painéis)
set -g mouse on

# Navegar entre abas (janelas) usando Alt + Setas (Sem precisar de prefixo)
bind -n M-Left  previous-window
bind -n M-Right next-window

# Navegar entre abas usando Alt + Número (Alt+1, Alt+2, etc)
bind -n M-1 select-window -t 1
bind -n M-2 select-window -t 2
bind -n M-3 select-window -t 3
bind -n M-4 select-window -t 4
bind -n M-5 select-window -t 5

# Criar nova aba com Alt + n
bind -n M-n new-window -c "#{pane_current_path}"

# Fechar aba atual com Alt + w
bind -n M-w kill-window

# Melhorar cores do terminal
set -g default-terminal "screen-256color"

# Barra de status mais limpa
set -g status-bg black
set -g status-fg white
EOC

echo "Recarregando configuração do Tmux..."
tmux source-file ~/.tmux.conf 2>/dev/null

echo "Pronto! Agora você pode usar Alt + Setas ou Alt + Números para navegar."
EOF

# Dar permissão de execução e rodar
chmod +x setup_tmux.sh
./setup_tmux.sh
