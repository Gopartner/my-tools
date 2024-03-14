#!/bin/bash

# Mendapatkan alamat IP perangkat kedua
target_ip=$(ip addr show wlan0 | awk '/inet / {print $2}' | cut -d '/' -f 1)

# Mendapatkan nama pengguna perangkat kedua
target_user=$(whoami)

echo "Informasi untuk perangkat:"
echo "Alamat IP perangkat: $target_ip"
echo "Username perangkat: $target_user"

