#!/bin/bash

git clone https://github.com/shirkdog/pulledpork
cd pulledpork

#move our config over top the default
cp ../config/pulledpork.conf etc/pulledpork.conf

./pulledpork.pl -c etc/pulledpork.conf -p /usr/local/bin/snort -P -S 3.1.1.0

#Rules saved to /usr/local/etc/snort/rules/snort.rules

#Convert pulledpork Snort2.x rules to Snort3 rules
snort2lua -c /usr/local/etc/snort/rules/snort.rules -r /usr/local/etc/snort/rules/snort.rules

cd ../

bash ./snort-config.sh

