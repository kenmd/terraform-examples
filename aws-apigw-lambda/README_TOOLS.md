# Tools Setup

How to setup VSCode, Python, SAM and Terraform on Mac


```bash
brew update && brew upgrade && brew cask upgrade

# VSCode
brew cask install visual-studio-code
# VSCode Extensions
code --install-extensions mauve.terraform

# Python 3.8
brew install pyenv pipenv
# see doc to setup
# https://github.com/pyenv/pyenv
# https://github.com/pypa/pipenv

# AWS CLI SAM
brew install awscli
brew tap aws/tap
brew install aws-sam-cli

# Terraform
brew install terraform
brew tap wata727/tflint
brew install tflint
```
