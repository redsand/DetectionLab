#!/bin/bash

rsyslogd -v >/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
	# rsyslog
	echo '*.*                       @@192.168.38.111' >> /etc/rsyslog.conf
	echo '*.*                       @@192.168.38.105' >> /etc/rsyslog.conf
	systemctl restart rsyslog.service
	systemctl enable rsyslog.service
else
	echo "Rsyslog server not found"
fi

