#!/data/data/com.termux/files/usr/bin/bash
# Termux Ubuntu Masaüstü Scripti - Basit Kurulum için

# Masaüstü kurulumu için temel işlevler
install_desktop() {
    echo "Ubuntu kurulumu başlıyor..."
    
    # Proot Distro kurulumu
    pkg install proot-distro -y
    proot-distro install ubuntu
    echo "Ubuntu kuruldu."

    # Ubuntu içinde masaüstü ortamı kur
    proot-distro login ubuntu -- bash -c "
        apt update -y && apt upgrade -y
        apt install xfce4 xfce4-goodies xterm -y
        apt install arc-theme papirus-icon-theme curl wget git -y
        curl -fsSL https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64 -o vscode.deb
        dpkg -i vscode.deb || apt --fix-broken install -y
        rm vscode.deb
        apt install wine gdebi -y
    "
    echo "Masaüstü ortamı ve uygulamalar kuruldu."
}

# Masaüstü başlatma işlevi
start_desktop() {
    echo "Masaüstü ortamı başlatılıyor..."
    proot-distro login ubuntu -- bash -c "
        export DISPLAY=:1
        xfce4-session &
    "
    echo "Masaüstü başlatıldı. Termux11 ile bağlanabilirsiniz."
}

# Masaüstü durdurma işlevi
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
