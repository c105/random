#!/data/data/com.termux/files/usr/bin/bash

# Function to check if a command was successful
check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Start VNC server
echo "Starting VNC server on display :1..."
vncserver :1
check_success "Failed to start VNC server."

# Set DISPLAY variable
export DISPLAY=:1

# Start NoVNC server
echo "Starting NoVNC server..."
cd noVNC || { echo "NoVNC directory not found. Please clone it first."; exit 1; }
./utils/launch.sh --vnc localhost:5901 &
check_success "Failed to start NoVNC server."

# Get IP address
IP=$(ifconfig wlan0 | grep 'inet ' | awk '{print $2}')

if [ -z "$IP" ]; then
    echo "Error: Could not retrieve IP address."
else
    echo "NoVNC is running. You can access it at:"
    echo "http://$IP:6080/vnc.html"
fi

# Launch Firefox with the correct DISPLAY variable
echo "Launching Firefox..."
DISPLAY=:1 firefox &
