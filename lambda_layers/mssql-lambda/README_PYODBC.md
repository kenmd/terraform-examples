# PYODBC Lambda Layer for SQL Server

Lambda Layer for Python 3.8 to access SQL Server


## Setup

* create pyodbc files into `layer-pyodbc/` directory
  - `/var/task` -> Lambda directory
  - `/opt`      -> Lambda Layer directory
* confirm the output at the end of `install_pyodbc.sh`

```bash
docker run -it --rm \
    -e ODBCINI=/opt/ \
    -e ODBCSYSINI=/opt \
    -v $PWD/layer-pyodbc:/opt \
    -v $PWD/install_pyodbc.sh:/install_pyodbc.sh \
    --entrypoint /install_pyodbc.sh \
    lambci/lambda:build-python3.8
```


## Test pyodbc

* first, start local SQL Server in `local-database/local-mssql`
* check the server by `sqlcmd -S 127.0.0.1,1433 -U sa -P $SA_PASSWORD`

```bash
docker run -it --rm -v $PWD/layer-pyodbc:/opt lambci/lambda:build-python3.8 bash
export ODBCINI=/opt/
export ODBCSYSINI=/opt
export PYTHONPATH=/opt/python:$PYTHONPATH
python
```

* Then paste the following code.

```python
import os
import pyodbc

# Note: PORT seems not working
driver = os.getenv("DB_DRIVER", '{ODBC Driver 17 for SQL Server}')
server = os.getenv("DB_SERVER", 'host.docker.internal,1433')
port = os.getenv("DB_PORT", "buggy")
database = os.getenv("DB_DATABASE", 'master')
uid = os.getenv("DB_UID", 'sa')
pwd = os.getenv("DB_PWD", 'Password1')

connection = (f"DRIVER={driver};SERVER={server};PORT={port};" +
              f"DATABASE={database};UID={uid};PWD={pwd}")

cnxn = pyodbc.connect(connection)
cursor = cnxn.cursor()

with cursor.execute("SELECT @@version;"):
    row = cursor.fetchone()
    print(row[0])
```
