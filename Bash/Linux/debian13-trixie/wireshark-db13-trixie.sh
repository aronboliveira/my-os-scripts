#!/usr/bin/env bash
sudo apt update -y && sudo apt install -y wireshark && \
echo "wireshark-common whireshark-common/install-setuid boolean true" | \
sudo debconf-set-selections && sudo dpkg-reconfigure -f noninteractive wireshark-common && \
sudo usermod -aG wireshark $USER && echo "Wireshark ready! Now reload!"
