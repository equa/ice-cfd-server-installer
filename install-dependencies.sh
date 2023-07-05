#!/usr/bin/bash

set -e

function fedora()
{
    sudo dnf groupinstall -y 'C Development Tools and Libraries' && \
    sudo dnf install -y \
        python3-pip \
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
        python3-pip \
        python3-venv \
        libglib2.0-dev \
        build-essential \
        uuid-dev \
        libgpgme-dev \
        squashfs-tools \
        libseccomp-dev \
        wget \
        pkg-config \
        cryptsetup-bin
}

function centos()
{
    sudo yum groupinstall -y 'Development Tools' && \
    sudo yum install -y \
        python3-pip \
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
    elif [ -x /usr/bin/dnf ]
    then
        echo -e "Installing dependencies with dnf"
        fedora
    elif [ -x /usr/bin/yum ]
    then
        echo -e "Installing dependencies with yum"
        centos
    elif [ -x /usr/bin/apt ]
    then
        echo -e "Installing dependencies with apt"
        ubuntu
    fi
done
