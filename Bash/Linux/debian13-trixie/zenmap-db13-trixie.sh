#!/usr/bin/env bash
echo "deb http://ftp.de.debian.org/debian trixie main" | \
sudo tee /etc/apt/sources.list.d/trixie.list
sudo apt update -y && sudo apt install -y nmap && nmap --version && \
echo "deb http://deb.debian.org/debian trixie-backports main" | \
sudo tee /etc/apt/sources.list.d/trixie-backports.list && \
sudo apt update -y && sudo apt install -y -t  trixie-backports nmap && \
nmap --version && sudo apt install -y nmap zenmap ncat ndiff
