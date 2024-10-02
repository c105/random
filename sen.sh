pkg update && pkg upgrade
pkg install x11-repo
pkg install tigervnc xfce4 firefox

pkg install git
git clone https://github.com/novnc/noVNC.git

vncserver :1

vncserver -kill :1

echo "#!/data/data/com.termux/files/usr/bin/bash
startxfce4 &" > ~/.vnc/xstartup
chmod +x ~/.vnc/xstartup

vncserver :1

cd noVNC
./utils/novnc_proxy --vnc localhost:5901

firefox &
