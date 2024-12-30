#!/bin/sh

usage() {
    cat 1>&2 <<EOF
dotfile:
      config - update configs
EOF
}

config() {
    echo "update .vimrc"
    if ln -sf "$PWD"/configs/.vimrc ~/.vimrc; then
        echo "done"
    fi

    echo "update .tmux.conf"
    if ln -sf "$PWD"/configs/.tmux.conf ~/.tmux.conf; then
        echo "done"
    fi

    echo "update ssh config"
    if install -o "$USER" "$PWD"/configs/.ssh_config ~/.ssh/config; then
        echo "done"
    fi

    echo "update ghostty config"
    if [ -d ~/.config/ghostty/ ]; then
        if ln -sf "$PWD"/configs/.ghostty ~/.config/ghostty/config; then
            echo "done"
        fi
    else
        echo "ghostty not installed"
    fi
}

main() {
    if [ "$1" = "config" ]; then
        config
    else
        usage
    fi
}

main "$@" || exit 1
