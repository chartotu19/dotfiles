#!/bin/bash
if ! command -v aws &> /dev/null ; then
    if [ "$(uname -s)" == "Darwin" ] ; then
        brew install awscli
    elif [ "$(uname -s)" == "Linux" ] ; then
        curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
        unzip -qo /tmp/awscliv2.zip -d /tmp
        sudo /tmp/aws/install
        rm -rf /tmp/awscliv2.zip /tmp/aws
    fi
fi
