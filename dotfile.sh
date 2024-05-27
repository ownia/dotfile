#!/bin/sh

usage() {
    cat 1>&2 <<EOF
dotfile:
      config - update configs (vim, tmux)
EOF
}

config() {
    echo "update .vimrc"
    if cp configs/.vimrc ~/.vimrc; then
        echo "done"
    fi
    echo "update .tmux.conf"
    if cp configs/.tmux.conf ~/.tmux.conf; then
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
