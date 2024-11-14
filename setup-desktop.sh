#!/data/data/com.termux/files/usr/bin/bash

# Ubuntu kurulum fonksiyonu
install_desktop() {
    echo "Ubuntu kurulumu başlatılıyor..."

    # Proot Distro ve Ubuntu kurulumu
    pkg install proot-distro -y
    proot-distro install ubuntu
    echo "Ubuntu kuruldu."

    # Ubuntu içinde XFCE masaüstü ortamı, VSCode ve Wine kurulumu
    proot-distro login ubuntu -- bash -c "
        apt update -y && apt upgrade -y
        apt install -y xfce4 xfce4-terminal dbus-x11 curl wget
        apt install -y arc-theme papirus-icon-theme  # Hafif ve modern görünüm için tema
        curl -fsSL https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64 -o vscode.deb
        dpkg -i vscode.deb || apt --fix-broken install -y  # VSCode kurulumu
        rm vscode.deb
        apt install -y wine  # Wine kurulumu
    "
    echo "Masaüstü ortamı, VSCode ve Wine kuruldu."
}

# Masaüstü başlatma fonksiyonu
start_desktop() {
    echo "Masaüstü ortamı başlatılıyor..."
    proot-distro login ubuntu -- bash -c "
        export DISPLAY=:1
        dbus-launch --exit-with-session xfce4-session &
    "
    echo "Masaüstü başlatıldı. Termux11 ile bağlanabilirsiniz."
}

# Masaüstü durdurma fonksiyonu
stop_desktop() {
    echo "Masaüstü ortamı kapatılıyor..."
    pkill -f xfce4-session
    echo "Masaüstü kapatıldı."
}

# Komut parametresine göre işlem yap
if [ "$1" == "install" ]; then
    install_desktop
elif [ "$1" == "start" ]; then
    start_desktop
elif [ "$1" == "stop" ]; then
    stop_desktop
else
    echo "Kullanım: $0 {install|start|stop}"
fi
