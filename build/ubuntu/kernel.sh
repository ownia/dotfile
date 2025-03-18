build() {
    rm *.deb

    cd noble/

    # slow steps
    #fakeroot debian/rules clean
    #fakeroot debian/rules binary-headers binary-generic binary-perarch skipdbg=false

    # fast steps
    export CC="ccache gcc"
    export CXX="ccache g++"
    make CC="ccache gcc" -j $(nproc --all) bindeb-pkg

    cd ../
}

reboot() {
    sudo dpkg -i linux*6.8.12*.deb
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
