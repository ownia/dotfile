#!/bin/sh

usage() {
    cat 1>&2 <<EOF
dotfile:
EOF
}

main() {
    usage
}

main "$@" || exit 1
