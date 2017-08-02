require 'spec_helper'

describe service('apache2') do
  it { should be_running }
  it { should be_enabled }
end
