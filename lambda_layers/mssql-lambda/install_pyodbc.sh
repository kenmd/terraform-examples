#!/bin/bash -eux

# MSODBC install script
# install to /opt/ (Lambda Layer directory)

# * official doc
#   - https://docs.microsoft.com/ja-jp/sql/connect/python/pyodbc/python-sql-driver-pyodbc?view=sql-server-2017
# * AWS EC2 Linux AMI with pyodbc, psqlODBC, Microsoft ODBC Drivers
#   - https://datalere.com/tips-guides/ec2-aws-linux-ami-pyodbc/
# * AWS Lambda + Microsoft SQL Server — How to..
#   - https://medium.com/faun/aws-lambda-microsoft-sql-server-how-to-66c5f9d275ed
# * pyodbc-unixODBC-lambda-layer
#   - https://gist.github.com/diriver63/b72a954fa0da4851d89e5086aa13c6e8
# * Note: Layer put to /opt and set path to /opt/python
#   - https://qiita.com/ttkiida/items/255b124a3cf180329c8a


# add MS repo
curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo
# check if packages-microsoft-com-prod has been added
yum repolist
# amzn repo priority turn off
/bin/sed -i -e 's/^enabled = 1$/enabled = 0/' /etc/yum/pluginconf.d/priorities.conf

# MSODBC install
# note: dependency unixODBC 2.3.x also installed
ACCEPT_EULA=Y yum install -y msodbcsql17
# required to install pyodbc
yum install -y unixODBC-devel

# check installed packages and /opt/odbcinst.ini has been created
yum list installed | grep -i odbc
odbcinst -j

# copy libodbc* to /opt/lib
mkdir -p /opt/lib
cp -p /usr/lib64/libodbc* /opt/lib/

# install pyodbc
pip install --upgrade pyodbc -t /opt/python

# one line test
export PYTHONPATH=/opt/python:$PYTHONPATH
python -c "import pyodbc; print(pyodbc.drivers());"
