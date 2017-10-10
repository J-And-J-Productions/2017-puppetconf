#!/bin/bash

script_name=$(basename $0)
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $# -lt 1 ]]; then
    echo "Usage: ${script_name} <aws-ec2-host-public-ip>"
    exit 1
fi

# create the module archive
tar czf master.tar.gz ${script_dir}/../testkitchen/ &> /dev/null

# push to remote and run apply
rsync master.tar.gz ubuntu@$1:

# Run puppet apply on remote host
ssh ubuntu@$1 'sudo /opt/puppetlabs/puppet/bin/puppet module install --force master.tar.gz'
ssh ubuntu@$1 'sudo /opt/puppetlabs/puppet/bin/puppet apply -v -e "include awsapache"'
