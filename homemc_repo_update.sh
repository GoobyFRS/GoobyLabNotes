#!/usr/bin/env sh

SERVICE=" minecraft_server"  # ← confirm this matches your actual service name

echo "Starting update..."

cd ~/HomeMC || { echo "Failed to cd into ~/HomeMC"; exit 1; }

sudo systemctl stop "$SERVICE"
echo "Server stopped."

git stash
git pull origin main
echo "Successfully pulled from repo."

git stash pop
echo "Stash popped!"

sudo systemctl start "$SERVICE"
echo "Server back online. Done."