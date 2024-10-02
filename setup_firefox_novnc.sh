#!/data/data/com.termux/files/usr/bin/bash

# Update and install necessary packages
echo "Updating package lists..."
pkg update && pkg upgrade -y

echo "Installing required packages..."
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
echo "Starting VNC server on display :1..."
vncserver :1

# Clone NoVNC repository if not already cloned
if [ ! -d "noVNC" ]; then
    echo "Cloning NoVNC repository..."
    git clone https://github.com/novnc/noVNC.git
else
    echo "NoVNC repository already exists."
fi

# Start NoVNC
echo "Starting NoVNC server..."
cd noVNC || { echo "Failed to enter noVNC directory"; exit 1; }
./utils/launch.sh --vnc localhost:5901 &

# Get IP address
IP=$(ifconfig wlan0 | grep 'inet ' | awk '{print $2}')

if [ -z "$IP" ]; then
    echo "Error: Could not retrieve IP address."
else
    echo "NoVNC is running. You can access it at:"
    echo "http://$IP:6080/vnc.html"
fi
