#!/bin/bash

#Author : Xinyi HUANG

echo "FCGI environment for CentOS/RHEL 6 64bit"
#--------------------------------------------
#Yum library
echo "Adding RPMForge Repository"
rpm -Uvh http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
echo "Adding EPEL Repository"
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
echo "Adding REMI Repository"
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm 
echo "Adding CentAlt Repository"
rpm -Uvh http://centos.alt.ru/repository/centos/6/x86_64/centalt-release-6-1.noarch.rpm
echo "Adding Webtatic Repository"
rpm -Uvh http://repo.webtatic.com/yum/el6/latest.rpm
echo "Installing CentAlt in CentOS/RHEL 6"
rpm -Uvh http://centos.alt.ru/repository/centos/6/x86_64/centalt-release-6-1.noarch.rpm


#--------------------------------------------
#Install Apache2
echo "Installing Apache2"
yum install httpd


#--------------------------------------------
#Install PHP and FastCGI
yum install php php-cli mod_fastcgi
service httpd restart

#--------------------------------------------
#C++/Java Development Kit

cd /var/www
#Download development kit
http://www.fastcgi.com/dist/fcgi.tar.gz

#1. unzip fcgi.tar.gz
cd /var/www/fcgi/libfcgi
#2. configure -> make -> make install

#3. Change headfile of fcgio.cpp
#add #include<stdio.h>

#4. Add lib
vim /etc/ld.so.conf
#add /usr/local/lib
/sbin/ldconfig –v
#--------------------------------------------
service httpd restart

