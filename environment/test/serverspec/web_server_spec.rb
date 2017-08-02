require_relative 'serverspec_helper'
require 'aws_serverspec_helpers'

set :host, '52.90.44.178'

describe 'web server' do
  describe package('puppet') do
    it { should be_installed }
  end

  describe service('apache2') do
    it { should be_running }
    it { should be_enabled }
  end

  describe port(80) do
    it { should be_listening }
  end
end
