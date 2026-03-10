#!/usr/bin/env bash
# ============================================================
#  Wireshark – installer with non-root capture support
#  Target: Ubuntu 24.04 LTS (Noble Numbat)
# ============================================================

set -euo pipefail

sudo apt update -y && sudo apt install -y wireshark && \
echo "wireshark-common wireshark-common/install-setuid boolean true" | \
sudo debconf-set-selections && sudo dpkg-reconfigure -f noninteractive wireshark-common && \
sudo usermod -aG wireshark $USER && echo "Wireshark ready! Now reload!"
