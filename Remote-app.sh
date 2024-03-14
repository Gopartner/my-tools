#!/bin/bash

# Fungsi untuk memeriksa dan menginstal paket yang dibutuhkan
check_and_install_dependencies() {
    local dependencies=("sshfs" "inotify-tools")
    for package in "${dependencies[@]}"; do
        if ! dpkg -l | grep -q $package; then
            echo "Memerlukan paket: $package"
            apt-get install -y $package
        fi
    done
}

# Fungsi untuk mendapatkan informasi perangkat 2
get_remote_device_info() {
    echo "Masukkan informasi untuk perangkat 2:"
    read -p "Alamat IP perangkat 2: " ip_address
    read -p "Username perangkat 2: " username
}

# Fungsi untuk melakukan setup otomatis
perform_automatic_setup() {
    echo "Melakukan setup otomatis..."
    check_and_install_dependencies
    get_remote_device_info
}

# Fungsi untuk mount folder perangkat 2
mount_remote_folder() {
    read -p "Masukkan path folder dari perangkat 2: " remote_folder
    read -p "Masukkan path folder lokal untuk mount: " local_mount_point
    sshfs $username@$ip_address:$remote_folder $local_mount_point
}

# Fungsi utama
main() {
    # Melakukan setup otomatis
    perform_automatic_setup

    # Memulai mounting folder perangkat 2
    echo "Memulai mounting folder perangkat 2..."
    mount_remote_folder

    echo "Folder dari perangkat 2 berhasil di-mount."
}

# Memanggil fungsi utama
main

