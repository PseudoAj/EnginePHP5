#!/bin/bash

# Pre set-up variables

GITDIR="/tmp/git"
ENGINEAPIGIT="https://github.com/wvulibraries/engineAPI.git"
ENGINEBRANCH="master"
ENGINEAPIHOME="/home/engineAPI"

SERVERURL="/home/engineAPIPHP5"
DOCUMENTROOT="public_html"
SITEROOT="/home/engineAPIPHP5/public_html/src"

#Add the RPM for PHP5.6 to CentOS7
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
echo -e "----Added the RPM for CentOS7----\n\n"

yum -y install httpd httpd-devel httpd-manual httpd-tools
echo -e "----Installed Apache----\n\n"

yum -y install mysql-connector-java mysql-connector-odbc mysql-devel mysql-lib mysql-server
echo -e "----Installed MySQL----\n\n"

yum -y install mod_auth_kerb mod_auth_mysql mod_authz_ldap mod_evasive mod_perl mod_security mod_ssl mod_wsgi
echo -e "----Installed Auth Plugins for MySQL----\n\n"

yum -y install php56w php56w-bcmath php56w-cli php56w-common php56w-gd php56w-ldap php56w-mbstring php56w-mcrypt php56w-mysql php56w-odbc php56w-pdo php56w-pear php56w-pear-Benchmark php56w-pecl-apc php56w-pecl-imagick php56w-pecl-memcache php56w-soap php56w-xml php56w-xmlrpc
echo -e "----Installed PHP 5.6----\n\n"

rm -f /etc/php.ini
ln -s /vagrant/serverConfiguration/php.ini /etc/php.ini
echo -e "----Replaced PHP configurations----\n\n"

yum -y install emacs emacs-common emacs-nox
echo -e "----Installed emacs----\n\n"

yum -y install git
echo -e "----Installed git package----\n\n"

mv /etc/httpd/conf.d/mod_security.conf /etc/httpd/conf.d/mod_security.conf.bak
systemctl start httpd
chkconfig httpd on
echo -e "----Apache configuration files----\n\n"

rm -f /etc/httpd/conf/httpd.conf
ln -s /vagrant/serverConfiguration/httpd.conf /etc/httpd/conf/httpd.conf
echo -e "----httpd configuaration files----\n\n"

mkdir -p $GITDIR
cd $GITDIR
git clone -b $ENGINEBRANCH $ENGINEAPIGIT
git clone https://github.com/wvulibraries/engineAPI-Modules.git

mkdir -p $SERVERURL/phpincludes/
ln -s /vagrant/template/* $GITDIR/engineAPI/engine/template/
ln -s $GITDIR/engineAPI-Modules/src/modules/* $GITDIR/engineAPI/engine/engineAPI/latest/modules/
ln -s /vagrant/engine/ $SERVERURL/phpincludes/
echo -e "----Cloned engineAPI----\n\n"

mkdir -p $SERVERURL/$DOCUMENTROOT
ln -s /vagrant/src $SITEROOT
ln -s $SERVERURL/phpincludes/engine/engineAPI/latest $SERVERURL/phpincludes/engine/engineAPI/4.0
echo -e "----public folder has been set----\n\n"

