# PyODBC Lambda Layer example

sample SAM app to access SQL Server using PyODBC Lambda Layer


## Setup

* see [README_PYODBC](README_PYODBC.md) to setup `layer-pyodbc/`

```bash
cd sam-app/
pipenv install
pipenv install --dev
pipenv shell
```


## Run

* first, start local SQL Server in `local-database/local-mssql`
* check the server by `sqlcmd -S 127.0.0.1,1433 -U sa -P $SA_PASSWORD`

```bash
# Test
python -m pytest tests/ -v -s
python -m pytest tests/ -v --cov=src --cov-report=html -s

# Run
sam build
sam local invoke HelloWorldFunction --event events/event.json
```


## Deploy

```bash
export AWS_PROFILE=xxx

cd terraform
terraform init

terraform version
Terraform v0.12.20
+ provider.archive v1.3.0
+ provider.aws v2.48.0

terraform plan
terraform apply
```


## Note

* initial setup commands for reference

```bash
sam init --runtime python3.8
cd sam-app/

pipenv --python 3.8
pipenv install --dev pylint autopep8 rope pytest pytest-mock pytest-cov
pipenv install -r hello_world/requirements.txt
```
