#!/data/data/com.termux/files/usr/bin/bash

# Stop the VNC server
echo "Stopping VNC server..."
vncserver -kill :1

# Stop NoVNC server
echo "Stopping NoVNC server..."
PKILL=$(pgrep -f "launch.sh")
if [ ! -z "$PKILL" ]; then
    kill $PKILL
    echo "NoVNC server stopped."
else
    echo "NoVNC server is not running."
fi

echo "All services stopped."
