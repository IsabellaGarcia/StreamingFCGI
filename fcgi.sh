#!/bin/bash

#source ./fcgi.sh

echo "FCGI environment for CentOS/RHEL 6 64bit"
#yum library
echo "Adding RPMForge Repository\n"
rpm -Uvh http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
echo "Adding EPEL Repository\n"
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
echo "Adding REMI Repository\n"
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm 
echo "Adding CentAlt Repository\n"
rpm -Uvh http://centos.alt.ru/repository/centos/6/x86_64/centalt-release-6-1.noarch.rpm
echo "Adding Webtatic Repository\n"
rpm -Uvh http://repo.webtatic.com/yum/el6/latest.rpm
echo "Installing CentAlt in CentOS/RHEL 6\n\n"
rpm -Uvh http://centos.alt.ru/repository/centos/6/x86_64/centalt-release-6-1.noarch.rpm

#Install Apache2
echo "Installing Apache2"
yum install httpd

#Install PHP and FastCGI
echo "Fast CGI\n\n\n"
yum install php php-cli mod_fastcgi
service httpd restart

#C++/Java Development Kit
DOWNLOAD_DIR=/var/www

cd $DOWNLOAD_DIR
echo "Development Kit for C++/Java"
if [ -e "./fcgi.tar.gz" ]; then
    rm -rf ./fcgi.tar.gz
fi

wget http://www.fastcgi.com/dist/fcgi.tar.gz

if [ -d "./unzip" ]; then
   echo "unzip file exist"
   rm -rf unzip
fi
   mkdir unzip

cd $DOWNLOAD_DIR
tar -xf fcgi.tar.gz -C unzip
cd ./unzip
cd *

#configuring and make
./configure
cd ./include
sed -i '34i\#include<cstdio>' fcgio.h
cd ..
make
make install

#4. Add lib
cd /etc
echo "/usr/local/lib" >> ld.so.conf
/sbin/ldconfig -v

cd /etc/httpd/conf
sed -i '275i\ServerName localhost:80' httpd.conf

#boost setup
yum install boost-devel

#delete files
cd $DOWNLOAD_DIR
rm -rf fcgi.tar.gz
rm -rf unzip

service httpd restart

echo "DONE"
