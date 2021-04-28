# AWS StepFunction Lambda Sample

## Setup

- [Setup Dev Tools](./README_DEV_TOOLS.md)
- [Step Functions Local](./README_LOCAL_SFN.md)

```bash
cd sam-app/

pipenv sync
pipenv sync --dev

pipenv shell
pipenv lock --keep-outdated --requirements > ./src/requirements.txt

python -m pytest tests/ -v
sam build
```

```bash
cd terraform/
export AWS_PROFILE=sample
export DB_PASSWORD=MySQL-Serverless
export TF_VAR_db_password=$DB_PASSWORD

terraform init
# if you setup S3 backend
# terraform init -backend-config sample_backend.tfvars

terraform plan -var-file sample_variables.tfvars
terraform apply -var-file sample_variables.tfvars
```

**Check RDS connection on jump server**

```bash
aws --version
aws-cli/1.18.10 Python/3.8.2 Darwin/19.3.0 botocore/1.15.10

session-manager-plugin --version
1.1.54.0

INSTANCE_ID=$(terraform output jump_server-id)
DB_ENDPOINT=$(terraform output db-endpont)

# login to the jump server
aws ssm start-session --target $INSTANCE_ID

# after login to the jump server
mysql -h $DB_ENDPOINT -P 3306 -u root -p$DB_PASSWORD
```

**Check RDS connection using ssh tunnel**

```bash
# login to the jump server
aws ssm start-session --target $INSTANCE_ID
# run on jump server
socat -v TCP4-LISTEN:13306,fork,reuseaddr TCP4:$DB_ENDPOINT:3306

# open another teminal and start SSH tunnel on Mac
aws ssm start-session --target $INSTANCE_ID \
    --document-name AWS-StartPortForwardingSession \
    --parameters '{"portNumber":["13306"],"localPortNumber":["23306"]}'

# route: 127.0.0.1,23306 -> jump server:13306 -> RDS:3306
mysql -h 127.0.0.1 -P 23306 -u root -p$DB_PASSWORD
```

**Setup test table in RDS MySQL**

- create PERSON table using `local-database/flyway-mysql`
- unfortunately `flyway` command will show the message below.

```
ERROR: Flyway Enterprise Edition or MySQL upgrade required:
MySQL 5.6 is no longer supported by Flyway Community Edition,
but still supported by Flyway Enterprise Edition.
```

- for now, execute sql files as below

```bash
mysql -h 127.0.0.1 -P 23306 -u root -p$DB_PASSWORD -D db_example \
    < sql/V1__Create_person_table.sql
mysql -h 127.0.0.1 -P 23306 -u root -p$DB_PASSWORD -D db_example \
    < sql/V2__Add_people.sql

mysql -h 127.0.0.1 -P 23306 -u root -p$DB_PASSWORD -D db_example \
    -e "show tables;"
mysql -h 127.0.0.1 -P 23306 -u root -p$DB_PASSWORD -D db_example \
    -e "select * from PERSON;"
```

## Run

```bash
NAME=hello-sfn

# List sfn
aws stepfunctions list-state-machines --output text

ARN=$(aws stepfunctions list-state-machines --query "stateMachines[?name=='${NAME}'].stateMachineArn" --output text)

# Show sfn
aws stepfunctions describe-state-machine --state-machine-arn $ARN

# Run sfn
aws stepfunctions start-execution --state-machine-arn $ARN

EXEC_ARN="arn:aws:states:ap-northeast-1:***:execution:$NAME:xxx-xxx"

# Check sfn result
aws stepfunctions describe-execution --execution-arn $EXEC_ARN

# the status should be RUNNING
```

## Call Back to Step Functions

- Send Success to the task

```bash
aws sqs list-queues --output text

QUEUE_URL="https://ap-northeast-1.queue.amazonaws.com/***/$NAME-dev"

aws sqs get-queue-attributes --queue-url $QUEUE_URL \
    --attribute-names ApproximateNumberOfMessages

aws sqs receive-message --queue-url $QUEUE_URL

HANDLE="xxxxx"
TOKEN="TaskToken"

aws sqs delete-message --queue-url $QUEUE_URL \
    --receipt-handle $HANDLE

aws stepfunctions send-task-success \
    --task-token $TOKEN \
    --task-output '{"status": "OK"}'
```
