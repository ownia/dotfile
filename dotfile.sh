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

    if [ -d ~/.config/ghostty/ ]; then
        echo "update ghostty config"
        if ln -sf "$PWD"/configs/.ghostty ~/.config/ghostty/config; then
            echo "done"
        fi
    fi

    if [ -d ~/.config/ibus/rime/ ]; then
        echo "update ibus-rime config"
        if ln -sf "$PWD"/configs/rime/default.custom.yaml ~/.config/ibus/rime/default.custom.yaml; then
            echo "done"
        fi
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
