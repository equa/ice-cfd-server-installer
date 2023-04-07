#!/usr/bin/bash

set -e

function fedora()
{
    sudo dnf groupinstall -y 'C Development Tools and Libraries' && \
    sudo dnf install -y \
    	openssl-devel \
    	libuuid-devel \
    	libseccomp-devel \
    	wget \
    	squashfs-tools \
    	cryptsetup
}

function ubuntu()
{
    sudo apt-get install -y \
        libglib2.0-dev \
        build-essential \
        uuid-dev \
        libgpgme-dev \
        squashfs-tools \
        libseccomp-dev \
        wget \
        pkg-config \
        git \
        cryptsetup-bin
}

function centos()
{
    sudo yum groupinstall -y 'Development Tools' && \
    sudo yum install -y \
        glib2-devel \
    	openssl-devel \
    	libuuid-devel \
    	libseccomp-devel \
    	wget \
    	squashfs-tools \
    	cryptsetup
}

for dist in fedora ubuntu centos
do
    if grep -qi $dist /proc/version
    then
        echo -e "Installing dependencies for $dist"
        $dist
    fi
done
