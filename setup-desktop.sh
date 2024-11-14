#!/data/data/com.termux/files/usr/bin/bash

# Ubuntu kurulum fonksiyonu
install_desktop() {
    echo "Ubuntu kurulumu başlatılıyor..."

    # Proot Distro ve Ubuntu kurulumu
    pkg install proot-distro -y
    proot-distro install ubuntu
    echo "Ubuntu kuruldu."

    # Ubuntu içinde XFCE masaüstü ortamı, Arc teması, VSCode ve Wine kurulumu
    proot-distro login ubuntu -- bash -c "
        apt update -y && apt upgrade -y
        apt install -y xfce4 xfce4-terminal dbus-x11 curl wget

        # Arc teması kurulumu
        apt install -y arc-theme
        echo 'Arc teması kuruldu. Hafif ve modern bir görünüm sağlanacak.'

        # Visual Studio Code kurulumu
        curl -fsSL https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64 -o vscode.deb
        dpkg -i vscode.deb || apt --fix-broken install -y
        rm vscode.deb
        echo 'Visual Studio Code kuruldu.'

        # Wine kurulumu
        apt install -y wine
        echo 'Wine kuruldu.'
    "
    echo "Masaüstü ortamı, Arc teması, VSCode ve Wine kuruldu."
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
