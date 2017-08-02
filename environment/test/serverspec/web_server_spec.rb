require_relative 'serverspec_helper'
require 'aws_serverspec_helpers'

set :host, '54.89.91.230'

describe 'web server' do
  describe service('apache2') do
    it { should be_running }
    it { should be_enabled }
  end
end
