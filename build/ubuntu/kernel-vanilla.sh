#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="$(cd -- "$SCRIPT_DIR/../../.." && pwd)"
LINUX_DIR="${LINUX_DIR:-$WORK_DIR/linux}"
PACKAGE_DIR="${PACKAGE_DIR:-$WORK_DIR}"

export DEBFULLNAME="Weizhao Ouyang"
export DEBEMAIL="o451686892@gmail.com"

build() {
    rm -f "$PACKAGE_DIR"/*.deb

    cd "$LINUX_DIR/" || return

    # disable dbg build
    ./scripts/config --disable DEBUG_INFO

    export CC="ccache gcc"
    export CXX="ccache g++"
    make CC="ccache gcc" -j "$(nproc --all)" bindeb-pkg

}

reboot() {
    local kernel_release kernel_version
    kernel_release="$(make -s -C "$LINUX_DIR" kernelrelease)" || return
    kernel_version="$(make -s -C "$LINUX_DIR" kernelversion)" || return

    mapfile -t debs < <(
        find "$PACKAGE_DIR" -maxdepth 1 -type f \
            \( -name "*${kernel_release}*.deb" -o -name "*${kernel_version}*.deb" \) \
            ! -name "*-dbg*.deb" \
            -print | sort
    )

    if ((${#debs[@]} == 0)); then
        printf 'No kernel packages for %s were found in %s\n' \
            "$kernel_release" "$PACKAGE_DIR" >&2
        printf 'Run %s build first.\n' "$0" >&2
        return 1
    fi

    sudo dpkg -i "${debs[@]}"

    sudo systemctl reboot
}

main() {
    if [ "$1" = "build" ]; then
        build
    elif [ "$1" = "reboot" ]; then
        reboot
    else
        echo "Nah"
    fi
}

main "$@" || exit 1
