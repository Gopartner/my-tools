#!/bin/bash

# Default path untuk perangkat 1 dan perangkat 2
DEFAULT_REMOTE_PATH="/home"
DEFAULT_LOCAL_PATH="$HOME/remote_mount"

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
    read -p "Masukkan path folder dari perangkat 2 (default: $DEFAULT_REMOTE_PATH): " remote_folder
    remote_folder="${remote_folder:-$DEFAULT_REMOTE_PATH}"  # Gunakan default jika input kosong
    read -p "Masukkan path folder lokal untuk mount (default: $DEFAULT_LOCAL_PATH): " local_mount_point
    local_mount_point="${local_mount_point:-$DEFAULT_LOCAL_PATH}"  # Gunakan default jika input kosong

    # Membuat direktori lokal jika belum ada
    mkdir -p "$local_mount_point"
    echo "Direktori $local_mount_point berhasil dibuat."

    # Memberikan izin yang sesuai untuk folder lokal
    chmod 755 "$local_mount_point"

    # Melakukan mounting
    sshfs $username@$ip_address:$remote_folder $local_mount_point

    # Memeriksa apakah mounting berhasil
    if [ $? -eq 0 ]; then
        echo "Folder dari perangkat 2 berhasil di-mount pada $local_mount_point."
    else
        echo "Gagal melakukan mounting folder dari perangkat 2."
    fi
}

# Fungsi utama
main() {
    # Melakukan setup otomatis
    perform_automatic_setup

    # Memulai mounting folder perangkat 2
    echo "Memulai mounting folder perangkat 2..."
    mount_remote_folder
}

# Memanggil fungsi utama
main

