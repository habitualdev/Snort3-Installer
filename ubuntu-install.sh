#!/bin/bash

#Night Owl Build
apt install -y gpg curl 

#Store some variables to make life easier
workdir=$(pwd)
echo $workdir
#Install Neccesary dependencies

apt-get install -y build-essential autotools-dev libdumbnet-dev libluajit-5.1-dev libpcap-dev zlib1g-dev pkg-config libhwloc-dev cmake liblzma-dev openssl libssl-dev cpputest libsqlite3-dev libtool uuid-dev asciidoc dblatex source-highlight w3m libtool git autoconf bison flex libcmocka-dev libnetfilter-queue-dev libunwind-dev libmnl-dev ethtool

### We'll start by building snort 3

#Safec will shore up any legacy C code library calls

mkdir safec
cd safec
wget https://github.com/rurban/safeclib/releases/download/v08112019/libsafec-08112019.0-gad76c7.tar.gz
tar -xzvf libsafec-08112019.0-gad76c7.tar.gz
cd libsafec-08112019.0-gad76c7/
./configure
 make
 make install
#move back to original directory
cd $workdir

#Install PCRE

mkdir pcre
cd pcre
wget https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz
tar -xzvf pcre-8.43.tar.gz
cd pcre-8.43
./configure
make
sudo make install
#Move up two
cd $workdir

#Install gperftools, google's memory allocator. Trade more memory usage for more Speeeeeeed

mkdir gperftools
cd gperftools
wget https://github.com/gperftools/gperftools/releases/download/gperftools-2.7.90/gperftools-2.7.90.tar.gz
tar xzvf gperftools-2.7.90.tar.gz
cd gperftools-2.7.90
./configure
make
make install
#You know the drill...
cd $workdir

#Now to grab some more C++ libraries
#First up is Ragel
mkdir ragel
cd ragel
wget http://www.colm.net/files/ragel/ragel-6.10.tar.gz
tar -xzvf ragel-6.10.tar.gz
cd ragel-6.10
./configure
make
make install
#Up we go!
cd $workdir

mkdir boost
cd boost
#These are Boost Libraries. We're not installing, just using for Hyperscan
wget https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz
tar -xvzf boost_1_72_0.tar.gz

cd $workdir

wget https://github.com/intel/hyperscan/archive/v5.2.1.tar.gz
tar -xvzf v5.2.1.tar.gz
mkdir hyperscan-5.2.1-build
cd hyperscan-5.2.1-build

cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBOOST_ROOT=$workdir/boost/boost_1_72_0/ $workdir/hyperscan-5.2.1
make
make install

#now to test Hyperscan - Commented out for now
#./bin/unit-hyperscan

#echo "Did Hyperscan run properly? y/n"

cd $workdir

#add optional memory efficiency library. We'll need it.
mkdir flatbuffers
cd flatbuffers
wget https://github.com/google/flatbuffers/archive/v1.12.0.tar.gz -O flatbuffers-v1.12.0.tar.gz
tar -xzvf flatbuffers-v1.12.0.tar.gz
mkdir flatbuffers-build
cd flatbuffers-build
cmake ../flatbuffers-1.12.0
make
make install
cd $workdir

#One last library, and it's an important one
mkdir daq
cd daq
git clone https://github.com/snort3/libdaq.git
cd libdaq
./bootstrap
./configure
make
make install
cd $workdir

#Update all shared libraries
ldconfig

#Hey, now we finally pull snort 3
git clone git://github.com/snortadmin/snort3.git
cd snort3
./configure_cmake.sh --prefix=/usr/local --enable-tcmalloc
cd build
make
make install

#Now we test snort - Commented out for now
#/usr/local/bin/snort -V

#Create and begin filling a config folder
mkdir -p /usr/local/etc/snort/rules/iplists 

cd $workdir

./ubuntu-pullpork.sh
