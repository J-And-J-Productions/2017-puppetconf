require 'serverspec'
require 'net/ssh'

set :backend, :ssh
set :ssh_options, :user => 'ubuntu'
set :os, :family => 'ubuntu', :release => '17.04', :arch => 'x86_64'
