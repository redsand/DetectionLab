

export HAWK_USERNAME="hawkio-lab"
export HAWK_PASSWORD="$HAWK_LICENSE"

echo "username=$HAWK_USERNAME" >> /etc/yum.conf
echo "password=$HAWK_PASSWORD" >> /etc/yum.conf

rpm -vhU https://$HAWK_USERNAME:$HAWK_PASSWORD@mirror.hawk.io/repos/hawk/5.2/HAWK7/x86_64/hawk-repo-5.2.2-1.hwk7.noarch.rpm

# installer
firewall-cmd --permanent --add-port=8443/tcp

# UX
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --permanent --add-port=8080/tcp

# syslog
firewall-cmd --permanent --add-port=514/udp
firewall-cmd --permanent --add-port=514/tcp
firewall-cmd --permanent --add-port=8515/tcp

firewall-cmd --reload

rpm --nodeps -e mariadb-libs

yum -y install MySQL-client

echo "{'archive_path': '/archives', 'msgd_server': ['127.0.0.1'], 'api_server': '127.0.0.1', 'sys_password': 'vagrant', 'srv_password': 'bNIoEhX61dAfMmCgeuYP', 'sys_smtp_server_port': 25, 'aio_server': '127.0.0.1', 'kafka_size': 34, 'license_key': '${HAWK_PASSWORD}', 'mysql_pri_server': '127.0.0.1', 'sys_smtp_server': 'localhost', 'shard_name': 'data01', 'srv_username': 'hawk-service-accnt', 'mysql_replication': False, 'enable_trend_mode': False, 'admin_password': 'Password1', 'kafka_path': '/data/vStream-logs-01/', 'database_username': 'hawk', 'corporate_image': '/usr/share/hawk/HAWK-corp.png', 'sys_smtp_from': 'no-reply@hawk.io', 'api_secret': 'ytA4NWRLxOby5zOwSUqzTeJXlyz7HbYT58dExuOc', 'insecure': True, 'mysql_username': 'hawk', 'api_ssl_key': ['localhost.key', False], 'shard_path': '/data', 'sink_archive': 'false', 'root_password': 'Password1', 'iek_server': '127.0.0.1', 'iek_ssl_key': ['localhost.key', False], 'mysql_sec_server': None, 'kafka_server': ['127.0.0.1'], 'mysql_password': '2Rlr9fHjttbbGc3KtVd', 'api_ssl_cert': ['localhost.crt', False], 'ece_server': '127.0.0.1', 'install_type': 'all_in_one', 'sys_memcached': '8192', 'sys_username': 'root', 'sys_proxy_server': None, 'zoo_server': ['127.0.0.1'], 'sys_smtp_admins': [['Administrator', 'no-reply@hawk.io']], 'kafka_days': '90', 'database_password': '2Rlr9fHjttbbGc3KtVd', 'iek_ssl_cert': ['localhost.crt', False], 'sys_ssh_port': '22'}" > /tmp/config.$$

yum -y install hawk-install-web

# uncomment when ready
# nohup hawk-install-web -f /tmp/config.$$
nohup hawk-install-web &

rm -f /tmp/config.$$

cp /usr/share/zoneinfo/GMT /etc/localtime

yum -y install ntp

ntpdate -u time.nist.gov


# setup the install

