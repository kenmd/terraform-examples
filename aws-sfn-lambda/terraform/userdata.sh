#!/bin/sh -ex

# How can I log my EC2 Linux user-data and then ship it to the console logs?
# https://aws.amazon.com/premiumsupport/knowledge-center/ec2-linux-log-user-data/

# EC2 console > Actions > Instance Settings > Get System Log

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

yum -y update
echo "yum -y update DONE!"


# no need ssh anymore by Session Manager Port Forwarding
# https://aws.amazon.com/blogs/aws/new-port-forwarding-using-aws-system-manager-sessions-manager/

# /bin/sed -i -e 's/^#GatewayPorts no$/GatewayPorts yes/' /etc/ssh/sshd_config
# service sshd restart


# install the latest ssm agent
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl restart amazon-ssm-agent


yum install -y socat


# Install MySQL 5.7 client on Amazon Linux 2
# https://gist.github.com/sshymko/63ee4e9bc685c59a6ff548f1573b9c74
yum install -y https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
yum install -y mysql-community-client
