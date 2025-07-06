#!/bin/bash

# Script to install all available packages using apt

# Check if script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo."
  exit 1
fi

# Update package index
echo "Updating package index..."
apt update -y

# Get list of all available packages
echo "Fetching list of all available packages..."
packages=$(apt-cache pkgnames)

# Check if package list is empty
if [ -z "$packages" ]; then
  echo "Error: No packages found. Check repository configuration."
  exit 1
fi

# Install each package, skip if it fails
echo "Installing all packages (this may take a long time)..."
for package in $packages; do
  echo "Installing $package..."
  if apt install -y --force-yes "$package" 2>/dev/null; then
    echo "$package installed successfully."
  else
    echo "Warning: Failed to install $package (skipping)."
  fi
done

# Clean up
echo "Cleaning up..."
apt autoremove -y
apt autoclean

echo "Installation process complete!"