#!/bin/bash
##Snort 3 Build and Install
dnf -y config-manager --add-repo /etc/yum.repos.d/CentOS-Stream-PowerTools.repo
dnf -y config-manager --set-enabled powertools
dnf -y install epel-release
dnf -y upgrade
mkdir sources && cd sources
dnf -y install vim git
echo '/usr/local/lib' >> /etc/ld.so.conf.d/local.conf
echo '/usr/local/lib64' >> /etc/ld.so.conf.d/local.conf
ldconfig
dnf -y install flex bison gcc gcc-c++ make cmake automake autoconf libtool
dnf -y install libpcap-devel pcre-devel libdnet-devel hwloc-devel openssl-devel zlib-devel luajit-devel pkgconf libmnl-devel libunwind-devel
dnf -y install libnfnetlink-devel libnetfilter_queue-devel
git clone https://github.com/snort3/libdaq.git
cd libdaq/
./bootstrap
dnf -y install libcmocka-devel
./configure
make
make install
ldconfig
cd ../
dnf -y install xz-devel libuuid-devel
dnf -y install hyperscan hyperscan-devel
curl -Lo flatbuffers-1.12.tar.gz https://github.com/google/flatbuffers/archive/v1.12.0.tar.gz
tar xf flatbuffers-1.12.tar.gz
mkdir fb-build && cd fb-build
cmake ../flatbuffers-1.12.0
make -j$(nproc)
make -j$(nproc) install
ldconfig
cd ../
dnf -y install libsafec libsafec-devel
ln -s /usr/lib64/pkgconfig/safec-3.3.pc /usr/lib64/pkgconfig/libsafec.pc
dnf -y install gperftools-devel
git clone https://github.com/snort3/snort3.git
cd snort3/
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
export CFLAGS="-O3"
export CXXFLAGS="-O3 -fno-rtti"
./configure_cmake.sh --prefix=/usr/local/snort --enable-tcmalloc
cd build/
make -j$(nproc)
make -j$(nproc) install
cd ../../
/usr/local/snort/bin/snort -V
#Create and begin filling a config folder
mkdir -p /usr/local/etc/snort/rules/iplists

./centos-pullpork.sh
