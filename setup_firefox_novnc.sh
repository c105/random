#!/data/data/com.termux/files/usr/bin/bash

# Update and install necessary packages
pkg update && pkg upgrade -y
pkg install x11-repo -y
pkg install xfce4 xfce4-terminal tigervnc firefox python git -y

# Set VNC password
echo "Setting up VNC password..."
vncpasswd

# Create VNC xstartup file
echo "Creating VNC xstartup file..."
cat << EOF > ~/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
startxfce4 &
EOF

# Make xstartup executable
chmod +x ~/.vnc/xstartup

# Start VNC server
echo "Starting VNC server..."
vncserver :1

# Clone NoVNC repository
if [ ! -d "noVNC" ]; then
    echo "Cloning NoVNC repository..."
    git clone https://github.com/novnc/noVNC.git
fi

# Start NoVNC
echo "Starting NoVNC server..."
cd noVNC
./utils/launch.sh --vnc localhost:5901 &

# Get IP address
IP=$(ifconfig wlan0 | grep 'inet ' | awk '{print $2}')

echo "NoVNC is running. You can access it at:"
echo "http://$IP:6080/vnc.html"

# Launch Firefox
echo "Launching Firefox..."
firefox &
