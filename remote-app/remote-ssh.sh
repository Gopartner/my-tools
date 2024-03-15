#!/bin/bash

# Fungsi untuk menampilkan menu utama
function main_menu {
    clear
    echo "=== Main Menu ==="
    echo "Sistem Operasi: $os"
    echo "1. Client"
    echo "2. Server"
    echo "3. Keluar"
    read -p "Pilih peran Anda (1/2/3): " choice
    case $choice in
        1) client_menu ;;
        2) server_menu ;;
        3) exit ;;
        *) echo "Pilihan tidak valid" ;;
    esac
}

# Fungsi untuk menampilkan menu client
function client_menu {
    clear
    echo "=== Client Menu ==="
    echo "Sistem Operasi: $os"
    echo "1. Remote ke server"
    echo "2. Keluar"
    read -p "Pilih menu: " choice
    case $choice in
        1) remote_to_server ;;
        2) main_menu ;;
        *) echo "Pilihan tidak valid" ;;
    esac
}

# Fungsi untuk remote ke server
function remote_to_server {
    if [ "$os" == "Linux" ] || [ "$os" == "Darwin" ]; then
        read -p "Masukkan alamat IP server: " server_ip
        read -p "Masukkan username server: " server_username
        read -p "Masukkan port SSH server: " server_port

        # Remote menggunakan SSH
        ssh $server_username@$server_ip -p $server_port
    elif [ "$os" == "Android" ]; then
        # Install openssh jika belum ada
        if ! command -v ssh &> /dev/null; then
            echo "Sistem operasi Anda membutuhkan paket OpenSSH."
            echo "Memulai proses instalasi..."
            pkg install openssh -y
            if [ $? -eq 0 ]; then
                echo "OpenSSH berhasil diinstal."
            else
                echo "Gagal menginstal OpenSSH. Pastikan koneksi internet Anda baik."
                exit 1
            fi
        fi
        read -p "Masukkan alamat IP server: " server_ip
        read -p "Masukkan username server: " server_username
        read -p "Masukkan port SSH server: " server_port

        # Remote menggunakan SSH
        ssh $server_username@$server_ip -p $server_port
    elif [ "$os" == "Windows_NT" ]; then
        # Beri instruksi kepada pengguna Windows untuk menggunakan alat SSH mereka
        echo "Untuk menggunakan SSH di Windows, silakan gunakan alat SSH seperti PuTTY."
    elif [ "$os" == "Linux" ]; then
        # Sediakan instruksi penggunaan openssh-server untuk distro Linux
        echo "Untuk menggunakan SSH di Linux, pastikan openssh-server terinstal dan jalankan perintah 'ssh <username>@<server_ip>'"
    else
        echo "Sistem operasi tidak didukung."
    fi
}

# Fungsi untuk menampilkan menu server
function server_menu {
    clear
    echo "=== Server Menu ==="
    echo "Sistem Operasi: $os"
    echo "1. Tampilkan username dan alamat IP"
    echo "2. Tampilkan path tersedia"
    echo "3. Keluar"
    read -p "Pilih menu: " choice
    case $choice in
        1) display_username_ip ;;
        2) display_available_path ;;
        3) main_menu ;;
        *) echo "Pilihan tidak valid" ;;
    esac
}

# Fungsi untuk menampilkan username dan alamat IP
function display_username_ip {
    echo "Username: $(whoami)"
    if [ "$os" == "Linux" ]; then
        echo "Alamat IP: $(ifconfig | grep -oE "inet (addr:)?([0-9]*\.){3}[0-9]*" | grep -oE "([0-9]*\.){3}[0-9]*" | grep -v "127.0.0.1" | head -n 1)"
    elif [ "$os" == "Darwin" ]; then
        echo "Alamat IP: $(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -n 1)"
    elif [ "$os" == "Android" ]; then
        echo "Alamat IP: $(ip addr show | grep inet | grep -v "127.0.0.1" | awk '{print $2}' | cut -d '/' -f 1)"
    else
        echo "Alamat IP: Tidak dapat ditemukan pada sistem ini."
    fi
}

# Fungsi untuk menampilkan path tersedia di server
function display_available_path {
    echo "Path tersedia pada server:"
    ls -d */ 2>/dev/null || echo "Tidak ada path yang tersedia."
    read -p "Tekan Enter untuk kembali ke menu server..."
    server_menu
}

# Cek sistem operasi
os=$(uname -s)
if [ "$os" != "Linux" ] && [ "$os" != "Darwin" ] && [ "$os" != "Android" ] && [ "$os" != "Windows_NT" ]; then
    echo "Sistem operasi tidak didukung."
    exit 1
fi

# Cek ketersediaan jaringan
if ! ping -c 1 google.com &> /dev/null; then
    echo "Tidak dapat terhubung ke internet atau jaringan Anda buruk/terputus. Silakan cek koneksi Anda."
    echo "Program akan tetap berjalan hingga koneksi internet kembali normal."
    # Tambahkan perulangan untuk menunggu koneksi internet kembali normal
    while ! ping -c 1 google.com &> /dev/null; do
        sleep 10  # Tunggu 10 detik sebelum mencoba lagi
    done
    echo "Koneksi internet telah kembali normal. Melanjutkan program..."
fi

# Mulai menu utama
main_menu

