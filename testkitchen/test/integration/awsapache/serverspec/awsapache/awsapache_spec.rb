require 'spec_helper'

describe service('apache2') do
  it { should be_running }
  it { should be_enabled }
end

describe file('/etc/apache2/sites-enabled/25-www.example-1.com.conf') do
  it { should exist }
  it { should contain 'ServerName www.example-1.com' }
end

describe file('/etc/apache2/sites-enabled/25-www.example-2.com.conf') do
  it { should exist }
  it { should contain 'ServerName www.example-2.com' }
end

describe file('/etc/apache2/sites-enabled/12-www.example-3.com.conf') do
  it { should exist }
  it { should contain 'ServerName www.example-3.com' }
end

describe file('/etc/apache2/ports.conf') do
  it { should exist }
  it { should contain 'Listen 80' }
  it { should contain 'Listen 81' }
end