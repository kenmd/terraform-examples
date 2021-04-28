# Development Environment Setup

## Setup Development Tools

```bash
brew update && brew upgrade && brew cask upgrade

# VSCode
brew cask install visual-studio-code
# VSCode Extensions
code --install-extensions mauve.terraform

# Python and Pipenv
brew install pyenv pipenv

# AWS CLI SAM
brew install awscli@1   # note version 2 have sfn related issue
brew install jq
brew tap aws/tap
brew install aws-sam-cli

# Terraform
brew install terraform
brew tap wata727/tflint
brew install tflint
```

- install Session Manager Plugin for the AWS CLI
  - https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html

## Setup SAM app

```bash
# create initial code
# sam init -n sam-app -r python3.8 -d pip --app-template hello-world
cd sam-app/

# rename directory to src
# mv hello_world src
# perl -pi -e 's/hello_world/src/g' \
#     {README.md,template.yaml,tests/unit/test_handler.py}

# pipenv --python 3.8

# pipenv install -r src/requirements.txt
# pipenv install --dev pylint autopep8 rope pytest pytest-mock pytest-cov

pipenv install
pipenv install --dev
# or use pipenv sync
pipenv shell
```

setup local MySQL to run `pytest` and `sam local invoke`

- start Local MySQL `local-database/local-mysql`
- create PERSON table `local-database/flyway-mysql`

```bash
# Test
python -m pytest tests/ -v
python -m pytest tests/ -v --cov=src --cov-report=html
# Chrome > File > Open File... > open htmlcov/index.html

# Local Run
sam build
sam local invoke HelloWorldFunction --event events/event.json --env-vars env.json
```

## Pipenv Misc Commands

```bash
pipenv update --outdated    # check
pipenv update               # execute update
pipenv update --dev         # execute update dev

# remove unused packages
pipenv clean

# remove and recreate python virtual env
pipenv --rm
pipenv install
pipenv install --dev
```
