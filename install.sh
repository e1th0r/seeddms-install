#!/bin/sh
#Version 0.1
#date dom abr  6 11:35:41 VET 2014
#By e1th0r, hcolina@gmail.com
#This is an stupid script for install dms version 4.3.7
#Based from preview work for Eric Smith and distribuited with seeddms' sources
# TODO
# * Check automatically the last versions and use variables for that
# * Verify Debian dependencies automatically 
# * Use variables for user ubications 


SEED="seeddms-4.3.7.tar.gz"
SEED1="seeddms-4.3.7"

read -p "Press [Enter] key to start..."
clear
echo "************************************************************************"
echo "If you need mysql storage, please create mysql database and user "
echo "for seeddms first"
read -p "Press [Enter] key to next stage..."
clear
echo "************************************************************************"


wget http://sourceforge.net/projects/seeddms/files/seeddms-4.3.7/seeddms-4.3.7.tar.gz/download
echo "Moving ... "
mv download seeddms-4.3.7.tar.gz

wget http://sourceforge.net/projects/seeddms/files/seeddms-4.3.7/SeedDMS_Preview-1.1.1.tgz/download
echo "Moving ... "
mv download SeedDMS_Preview-1.1.1.tgz

wget http://sourceforge.net/projects/seeddms/files/seeddms-4.3.7/SeedDMS_Lucene-1.1.4.tgz/download
echo "Moving ... "
mv download SeedDMS_Lucene-1.1.4.tgz

wget http://sourceforge.net/projects/seeddms/files/seeddms-4.3.7/SeedDMS_Core-4.3.7.tgz/download
echo "Moving ... "
mv download SeedDMS_Core-4.3.7.tgz 

echo "Installing pear components"
##Install as follows the pear components:
pear install SeedDMS_Core-4.3.7.tgz
pear install SeedDMS_Preview-1.1.1.tgz
pear install SeedDMS_Lucene-1.1.4.tgz

#Download and install the pear Log application:
#wget http://download.pear.php.net/package/Log-1.12.7.tgz
#sudo pear install Log-1.12.7.tgz

echo "Installing zend"
pear channel-discover zend.googlecode.com/svn
pear install zend/zend

#I installed the following packages, not all of which may be required
#and you may require other packages, please check the dependencies on
#the README.md for example for full text search, you need pdftotext,
#catdoc, xls2csv or scconvert, cat, id3 

#sudo apt-get install php5-mysql php5-mysqlnd libapache2-mod-php5
#sudo apt-get install pdo_mysql php5-gd id3 scconvert
#sudo apt-get install php-http-webdav-server
#sudo apt-get install zend-framework zend-framework-bin
#sudo apt-get install libzend-framework-zendx-php
#sudo apt-get install libjs-dojo-core libjs-dojo-dijit libjs-dojo-dojox
#sudo apt-get install libzend-framework-php (It kept bitching about Zend so I just kept piling on packages until it worked)

#mbstring is already a part of libapache2-mod-php5
#pepper:~> show libapache2-mod-php5|grep mbstring
# mbstring mhash openssl pcre Phar posix Reflection session shmop SimpleXML
 

#Define three locations:
#[1] Some cosy place in yourfile system for the source files to which you
#will link
#I chose "/opt/seeddms-4.0.0-pre5/"
#untar seeddms-4.0.0-pre5.tar.gz into this location

echo "Copying $SEED"
cp $SEED /opt/
cd /opt/
tar xvfz $SEED

echo "Making subdirectories needed"

#[2] Make a directory and three subdirectories for the data for your site;
#I chose to do this under "/opt/dms/seeddms_multisite_test/data"
mkdir -p /opt/dms/seeddms_multisite_test/data/lucene/
mkdir /opt/dms/seeddms_multisite_test/data/staging/
mkdir /opt/dms/seeddms_multisite_test/data/cache/

echo "Changing permisology"
chown -cvR  www-data  /opt/dms/seeddms_multisite_test/data/

mkdir /var/www/documentos
cd /var/www/documentos

echo "Creating simbolic links"
ln -s /opt/$SEED1 src

ln -s src/inc inc
ln -s src/op op
ln -s src/out out
ln -s src/js js
ln -s src/views views
ln -s src/languages languages
ln -s src/styles styles
ln -s src/themes themes
ln -s src/install install
ln -s src/index.php index.php

#Added another one
ln -s src/conf conf

echo "Creating file ENABLE_INSTALL_TOOL for installation"
#We need add this file, missing from the original recipe
touch conf/ENABLE_INSTALL_TOOL 

#If need be;
chown -cvR  www-data /var/www/documentos/
chown -cvR  www-data /var/www/documentos/src/

#For testing purposes is better to use sqlite because you don't need mysql
#Create Dataabse;
#Run the following sql commands to create your db and a user with
#appropriate privileges.

#mysql> create database seeddms_multisite_test;
#mysql> grant all privileges on seeddms_multisite_test.* to seeddms@localhost identified by 'your_passwd';

read -p "Press [Enter] key to finish..."
clear
echo "************************************************************************"
echo "Dont forget erase file ENABLE_INSTALL_TOOL from /var/www/documentos/conf"
echo "Go to http://127.0.0.1/documentos/ and finish the installation process"
echo "Finally you need use admin like user and password"
echo "************************************************************************"
