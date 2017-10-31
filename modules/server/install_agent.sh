#!/bin/bash

yum update
yum install -y ntpdate vim mc git tree net-tools
timedatectl set-timezone Europe/Kiev
ntpdate pool.ntp.org
sed -i 's/server 0.centos.pool.ntp.org/server 0.ua.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 1.centos.pool.ntp.org/server 1.ua.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 2.centos.pool.ntp.org/server 2.ua.pool.ntp.org/g' /etc/ntp.conf
sed -i 's/server 3.centos.pool.ntp.org/server 3.ua.pool.ntp.org/g' /etc/ntp.conf
rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum -y install puppet-agent
SERVERHOSTNAME=`/usr/bin/curl http://169.254.169.254/latest/meta-data/local-hostname`
echo """
[main]
certname = $SERVERHOSTNAME
server = ${dns_name}
environment = production
runinterval = 1m
""" >> /etc/puppetlabs/puppet/puppet.conf
/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
