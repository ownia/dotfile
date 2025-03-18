#!/bin/sh

# https://canonical-kteam-docs.readthedocs-hosted.com/en/public/how-to/build-kernel.html
# https://wiki.ubuntu.com/Kernel/BuildYourOwnKernel

# Ubuntu 24.04 Noble Numbat
#UBUNTU_VERSION="noble"
#UBUNTU_KERNEL_VERSION="6.8.12"

# Ubuntu 25.04 Plucky Puffin
UBUNTU_VERSION="plucky"
UBUNTU_KERNEL_VERSION="6.14.0"

build() {
    rm ./*.deb

    cd $UBUNTU_VERSION/ || exit

    # slow steps
    #fakeroot debian/rules clean
    #fakeroot debian/rules binary-headers binary-generic binary-perarch skipdbg=false

    # fast steps
    export CC="ccache gcc"
    export CXX="ccache g++"
    make CC="ccache gcc" -j "$(nproc --all)" bindeb-pkg

    cd ../
}

reboot() {
    sudo dpkg -i linux*$UBUNTU_KERNEL_VERSION*.deb
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
