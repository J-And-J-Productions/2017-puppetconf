require_relative 'serverspec_helper'
require 'aws_serverspec_helpers'
require 'net/http'

set :host, 'example1.pupperlabs.com'

describe 'web server' do
  describe package('puppet-agent') do
    it {should be_installed}
  end

  describe service('apache2') do
    it {should be_running}
    it {should be_enabled}
  end

  describe port(80) do
    it {should be_listening}
  end

  it 'should successfully call the example1 endpoint' do
    uri = URI "http://example1.pupperlabs.com"
    response = Net::HTTP.get_response uri
    expect(response.code).to eql '200'
    expect(response.body).to contain('A generic webpage')
  end

  # it 'should successfully call the example2 endpoint' do
  #   uri = URI "http://example2.pupperlabs.com"
  #   response = Net::HTTP.get_response uri
  #   expect(response.code).to eql '200'
  #   expect(response.body).to contain('A second generic page')
  # end

end
