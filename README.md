# August 2017 Des Moines AWS Meetup

The slides from this presentation are committed in both [pdf](2017-08-02-AWS-Meetup.pdf) and [powerpoint](2017-08-02-AWS-Meetup.pptx) format. Know that the powerpoint is going to provide the superior gif experience.

## Prerequisites

* Ruby: I'd recommend using rvm (http://rvm.io/) The version of ruby I've been running is 2.3.4p301
* Bundler: Once you've installed ruby then you run `gem install bundler`

## Terraform "stuff"

If you have an AWS key standing up an environment is as simple as running the following commands inside of the environment directory

    terraform plan    # to verify the changes that will be made
    terraform apply   # to apply those changes
    terraform destroy # to tear the environment down

## Integration Test "stufff"

Also inside of the environment directory here are the commands that will help you in running tests

    bundle install              # will install the necessary gems for running tests (assumes you've installed bundler)
    rake -T                     # to view the available rake tasks
    rake spec:aws_integration   # to run the integration tests that will verify your enviornment is properly configured
    rake spec:serverspec        # to run the integration tests that will verify your server configurations are properly applied

## Puppet "stuff"

If you'd like to experiment with testing puppet modules you will run these commands inside of the testkitchen directory

    rake -T          # to view the available rake tasks
    kitchen converge # to "assemble" your testing environment. This will stand up an environment as defined by .kitchen.yml and apply your the puppet module to it.
    kitchen verify   # to run the tests in the included test suite (located within the test directory)
    kitchen login    # to connect to the running environment. This can be good for debugging.
    kitchen destroy  # to destroy your testing environmenbt
