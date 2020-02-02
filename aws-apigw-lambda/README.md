
# AWS Terraform API Gateway starter

* based on https://learn.hashicorp.com/terraform/aws/lambda-api-gateway
* 3 types of lambda apps (see `lambda.tf`)
  - `lambda/src`: simple python app (no need to setup SAM app)
  - `sam-app`: AWS SAM Python app
  - `my-service`: AWS SAM Java Spring Boot app


## How to setup

### tools setup

[README_TOOLS.md](README_TOOLS.md)

### app setup

[README_APPS.md](README_APPS.md)

### AWS infra setup

```bash
cd terraform
terraform init  # run this only the first time

# if you need backend s3
# terraform init -backend-config sample_backend.tfvars

# use -var-file for different environment (prod/stage etc)
terraform plan # -var-file sample.tfvars
terraform apply # -var-file sample.tfvars

# note the outputs: base_url
```


## How to run

```bash
# for Python app
curl "$(terraform output base_url)/hoge?name=fuga"

# for Java Spring Boot app
curl "$(terraform output base_url)/ping"
```

### Summary of the event from the curl

```json
{
    "resource": "/{proxy+}",
    "path": "/hoge",
    "httpMethod": "GET",
    "headers": {
        "Accept": "* /*"
    },
    "queryStringParameters": {
        "name": "fuga"
    },
    "multiValueQueryStringParameters": {
        "name": [
            "fuga"
        ]
    },
    "pathParameters": {
        "proxy": "hoge"
    },
    "requestContext": {
        "resourcePath": "/{proxy+}",
        "httpMethod": "GET",
        "path": "/test/hoge",
        "protocol": "HTTP/1.1",
        "stage": "test"
    }
}
```


## Clean up

```bash
terraform destroy # -var-file default.tfvars
```


## Reference

* SAM
  - https://aws.amazon.com/serverless/sam/resources/
* Serverless Java container - Quick start Spring Boot
  - https://github.com/awslabs/aws-serverless-java-container/wiki/Quick-start---Spring-Boot
