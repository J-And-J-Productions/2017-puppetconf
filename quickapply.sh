#!/bin/bash

script_name=$(basename $0)

if [[ $# -lt 1 ]]; then
    echo "Usage: ${script_name} <aws-ec2-host-public-ip>"
    exit 1
fi

# create the module archive
tar czf master.tar.gz testkitchen/ &> /dev/null

# push to remote and run apply
rsync master.tar.gz ubuntu@$1:

# Run puppet apply on remote host
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@$1 'sudo /opt/puppetlabs/puppet/bin/puppet module install --force master.tar.gz'
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@$1 'sudo /opt/puppetlabs/puppet/bin/puppet apply -v -e "include awsapache"'
