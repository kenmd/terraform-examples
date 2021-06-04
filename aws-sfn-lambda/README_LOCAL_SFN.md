# Step Functions Local

## Setup

- start Local MySQL `local-database/local-mysql`
- create PERSON table `local-database/flyway-mysql`

```bash
NAME=hello-sfn
ACCOUNT=123456789012                # sfn local default account
FUNCTION_NAME=HelloWorldFunction    # c.f. template.yaml
SFN_NAME=$NAME
SNS_NAME=$NAME
SQS_NAME=$NAME
```

### start local lambda

```bash
cd sam-app/
sam local start-lambda --region ap-northeast-1
# Running on http://127.0.0.1:3001/

# test run
aws lambda invoke \
    --endpoint-url "http://127.0.0.1:3001" \
    --function-name $FUNCTION_NAME \
    --payload fileb://events/event.json \
    --no-verify-ssl \
    /tmp/out.txt

# NOTE: fileb or --cli-binary-format raw-in-base64-out
# https://stackoverflow.com/questions/60970252/aws-lambda-invoke-with-payload-from-cli
# https://aws.amazon.com/blogs/developer/best-practices-for-local-file-parameters/
```

### start local sns sqs sfn

```bash
TMPDIR=/private$TMPDIR docker-compose up

aws sns create-topic --endpoint-url http://localhost:4575 --name $SNS_NAME
aws sns list-topics --endpoint-url http://localhost:4575 --output text
# arn:aws:sns:ap-northeast-1:000000000000:hello-sfn

aws sqs create-queue --endpoint-url http://localhost:4576 --queue-name $SQS_NAME
aws sqs list-queues --endpoint-url http://localhost:4576 --output text
# http://localhost:4576/queue/hello-sfn
```

## Run Sfn

```bash
cd aws-sfn-lambda/

lambda_arn="arn:aws:lambda:ap-northeast-1:${ACCOUNT}:function:${FUNCTION_NAME}"
sqs_url="http:\/\/host.docker.internal:4576\/queue\/$NAME"

# replace variables in sfn definition
sed -e "s/\${lambda_arn}/$lambda_arn/g" terraform/sfn_definition.json > /tmp/sfn_definition_tmp.json
sed -e "s/\${sqs_url}/$sqs_url/g" /tmp/sfn_definition_tmp.json > /tmp/sfn_definition.json

# state machine setup
aws stepfunctions create-state-machine \
    --endpoint-url http://localhost:8083 \
    --name $SFN_NAME \
    --definition file:///tmp/sfn_definition.json \
    --role-arn "arn:aws:iam::${ACCOUNT}:role/DummyRole"

# state machine list
aws stepfunctions list-state-machines \
    --endpoint-url http://localhost:8083 \
    --output text

ARN=$(aws stepfunctions --endpoint-url http://localhost:8083 list-state-machines --query "stateMachines[?name==\`${SFN_NAME}\`].stateMachineArn" --output text)

# state machine definition
aws stepfunctions describe-state-machine \
    --endpoint-url http://localhost:8083 \
    --state-machine-arn $ARN

# Run
aws stepfunctions start-execution \
    --endpoint-url http://localhost:8083 \
    --state-machine-arn $ARN

# check the "executionArn" in the output above
EXEC_ARN="arn:aws:states:ap-northeast-1:************:execution:$NAME:xxxxx-xxx-xxxxx"

# Check sfn result
aws stepfunctions describe-execution \
    --endpoint-url http://localhost:8083 \
    --execution-arn $EXEC_ARN

# the "status" should be "RUNNING"
```

## Receive SQS message

```bash
# list local queues
aws sqs list-queues --endpoint-url http://localhost:4576 --output text

# number of messages in the local queue
aws sqs get-queue-attributes \
    --endpoint-url http://localhost:4576 \
    --queue-url http://localhost:4576/queue/$NAME \
    --attribute-names ApproximateNumberOfMessages

# number of messages which have been received from other program
aws sqs get-queue-attributes \
    --endpoint-url http://localhost:4576 \
    --queue-url http://localhost:4576/queue/$NAME \
    --attribute-names ApproximateNumberOfMessagesNotVisible

# receive one message from local queue
aws sqs receive-message \
    --endpoint-url http://localhost:4576 \
    --queue-url http://localhost:4576/queue/$NAME
```

```json
{
  "Messages": [
    {
      "MessageId": "120095e2-0978-4a1f-9232-1ca7464631b0",
      "ReceiptHandle": "120095e2-0978-4a1f-9232-1ca7464631b0#1a6f1a6f-2e3e-4a2c-adba-454f2e2f34ad",
      "MD5OfBody": "cd636c887a6149c28ee6b07f16115d1c",
      "Body": "{\"Input\":{\"status\":\"success\",\"result\":\"[[1, \\\"Axel\\\"], [2, \\\"Mr. Foo\\\"], [3, \\\"Ms. Bar\\\"]]\"},\"TaskToken\":\"07d673d6-144d-4a57-ba22-fb364d72e4d5\"}"
    }
  ]
}
```

```bash
# delete one message from local queue
aws sqs delete-message \
    --endpoint-url http://localhost:4576 \
    --queue-url http://localhost:4576/queue/$NAME \
    --receipt-handle "120095e2-0978-4a1f-9232-1ca7464631b0#1a6f1a6f-2e3e-4a2c-adba-454f2e2f34ad"
```

- send the TaskToken as SendTaskSuccess or as SendTaskFailure
  - https://docs.aws.amazon.com/ja_jp/step-functions/latest/dg/connect-to-resource.html

```bash
aws stepfunctions send-task-success \
    --endpoint-url http://localhost:8083 \
    --task-token "07d673d6-144d-4a57-ba22-fb364d72e4d5" \
    --task-output '{"status": "OK"}'

# Check sfn result again
# the "status" should be "SUCCEEDED"
```

## Clean up

```bash
docker-compose down
```

## Reference

- Setting Up Step Functions Local
  - https://docs.aws.amazon.com/step-functions/latest/dg/sfn-local.html
- SNS SQS on LocalStack
  - https://itneko.com/localstack-sns-sqs/
