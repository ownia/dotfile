#!/bin/sh

usage() {
    cat 1>&2 <<EOF
dotfile:
      config - update configs (vim, tmux)
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
    if ln -sf "$PWD"/configs/.ssh_config ~/.ssh/config; then
        echo "done"
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
