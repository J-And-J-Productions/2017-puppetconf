require 'spec_helper'

describe service('apache2') do
  it { should be_running }
  it { should be_enabled }
end

describe file('/etc/apache2/sites-enabled/25-example1.conf') do
  it { should exist }
  it { should contain 'ServerName example1'}
end

describe file('/etc/apache2/ports.conf') do
  it { should exist }
  it { should contain 'Listen 80' }
end
