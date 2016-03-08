#!/bin/bash

# Pre set-up variables

GITDIR="/tmp/git"
ENGINEAPIHOME="/home/engineAPI"

SERVERURL="/home/engineAPI"
DOCUMENTROOT="public_html"
TEMPLATES=$GITDIR/engineAPITemplates
MODULES=$GITDIR/engineAPI-Modules

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

mkdir -p $GITDIR
cd $GITDIR
git clone https://github.com/wvulibraries/engineAPITemplates.git
git clone https://github.com/wvulibraries/engineAPI-Modules.git

mkdir -p $SERVERURL/phpincludes/
ln -s /vagrant/engine/ $SERVERURL/phpincludes/
echo -e "----Cloned engineAPI----\n\n"

ln -s /vagrant/public_html $SERVERURL/$DOCUMENTROOT

rm -f /etc/php.ini
rm -f /etc/httpd/conf/httpd.conf

ln -s /vagrant/sync/serverConfiguration/php.ini /etc/php.ini
ln -s /vagrant/sync/serverConfiguration/vagrant_httpd.conf /etc/httpd/conf/httpd.conf

mkdir -p $SERVERURL/$DOCUMENTROOT/javascript/
ln -s /tmp/git/engineAPI/engine/template/distribution/public_html/js $SERVERURL/$DOCUMENTROOT/javascript/distribution

mkdir -p /vagrant/sync/serverConfiguration/serverlogs
touch /vagrant/sync/serverConfiguration/serverlogs/error_log
/etc/init.d/httpd restart
echo -e "----Application specific migrations completed----\n\n"

/etc/init.d/mysqld start
mysql -u root < /vagrant/sync/sql/vagrantSetup.sql
mysql -u root EngineAPI < /vagrant/sync/sql/EngineAPI.sql
echo -e "----MySQL setup for engineAPI----\n\n"


