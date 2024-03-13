#!/bin/bash

# Fungsi untuk mengeksekusi perintah tree -L 2 -C
execute_tree_command() {
    clear
    echo "Perubahan terdeteksi pada: $1"
    echo "==========================="
    tree -L 2 -C
}

# Memantau perubahan dalam folder
while inotifywait -r -e modify,create,delete,move .; do
    echo "Perubahan terdeteksi"
    # Mencari tahu jenis perubahan
    event_type=$(inotifywait -r -q -e modify,create,delete,move --format '%e' .)
    # Menjalankan perintah tree -L 2 -C jika terdapat perubahan pada folder atau file
    if [[ $event_type == *"ISDIR"* ]]; then
        # Jika ada folder baru atau folder terpengaruh
        changed_item=$(inotifywait -r -q -e modify,create,delete,move --format '%w%f' .)
    else
        # Jika ada file baru atau file terpengaruh
        changed_item=$(inotifywait -r -q -e modify,create,delete,move --format '%w%f' .)
    fi
    # Jika ada perubahan, jalankan perintah tree -L 2 -C
    execute_tree_command "$changed_item"
done

