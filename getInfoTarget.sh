#!/bin/bash

# Menampilkan alamat IP perangkat 2
get_ip_address() {
    ifconfig | grep -E 'inet.*eth0' | awk '{print $2}' | cut -d':' -f2
}

# Menampilkan username perangkat 2
get_username() {
    whoami
}

# Menampilkan informasi yang dibutuhkan
main() {
    echo "Informasi untuk perangkat 1:"
    echo "==========================="
    echo "Alamat IP perangkat 2: $(get_ip_address)"
    echo "Username perangkat 2: $(get_username)"
}

# Memanggil fungsi utama
main

