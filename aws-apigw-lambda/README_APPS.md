# Setup Apps


## Python SAM app setup

```bash
# command used to create the initial sam-app
# sam init -n sam-app -r python3.8 -d pip --app-template hello-world

cd sam-app/
pipenv --python 3.8
pipenv sync     # or pipenv install

# command used to create the initial Pipfile
# pipenv install --dev pylint autopep8 rope pytest pytest-mock pytest-cov
# pipenv install -r hello_world/requirements.txt

# run test
pipenv shell
python -m pytest tests/ -v

# test with coverage
python -m pytest tests/ -v \
    --cov=src --cov-report=html --cov-report=term-missing
open htmlcov/index.html

# build and run lambda locally
sam build
sam local invoke HelloWorldFunction --event events/event.json
```

```bash
# test run lambda
aws lambda invoke \
    --profile=default \
    --region=ap-northeast-1 \
    --function-name=HelloWorldFunction /tmp/output.txt
```


## Java Spring Boot SAM app setup

```bash
# command used to create the initial sam-app
# mvn archetype:generate -DgroupId=my.service -DartifactId=my-service -Dversion=1.0-SNAPSHOT \
#        -DarchetypeGroupId=com.amazonaws.serverless.archetypes \
#        -DarchetypeArtifactId=aws-serverless-springboot-archetype \
#        -DarchetypeVersion=1.4

cd my-service/
mvn clean package
mvn test
sam local start-api --template sam.yaml

curl -s http://127.0.0.1:3000/ping | python -m json.tool
{
    "pong": "Hello, World!"
}
```
