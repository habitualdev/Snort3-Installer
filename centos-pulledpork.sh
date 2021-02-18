#!/bin/bash

dnf -y install perl-libwww-perl perl-DBI perl-DBD-MySQL perl-GD perl-Sys-Syslog perl-LWP-Protocol-https
git clone https://github.com/shirkdog/pulledpork
cd pulledpork
#move our config over top the default
cp ../config/pulledpork.conf etc/pulledpork.conf
./pulledpork.pl -c etc/pulledpork.conf -p /usr/local/bin/snort -P 
#Rules saved to /usr/local/etc/snort/rules/snort.rules
#Convert pulledpork Snort2.x rules to Snort3 rules
/usr/local/snort/bin/snort2lua -c /usr/local/etc/snort/rules/snort.rules -r /usr/local/etc/snort/rules/snort.rules

cd ../
./snort-config.sh

