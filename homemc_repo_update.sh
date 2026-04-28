#!/usr/bin/env sh

SERVER_ROOT_PATH="/home/matt/HomeMC/"
START_PATH=$SERVER_ROOT_PATH/start.sh
STOP_PATH=$SERVER_ROOT_PATH/stop.sh
SERVICE="minecraft_server"  # ← confirm this matches your actual service name
 
echo "Starting update..."
 
cd ~/HomeMC || { echo "Failed to cd into ~/HomeMC"; exit 1; }
 
sudo systemctl stop "$SERVICE"
echo "Server stopped."
 
git stash
git pull origin main
echo "Successfully pulled from repo."
 
git stash pop
echo "Stash popped!"
 
sudo chmod +x $START_PATH
sudo chmod +x $STOP_PATH
echo "Scripts marked executable."
 
sudo systemctl start "$SERVICE"
echo "Server back online. Done."
