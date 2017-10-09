require_relative 'spec_helper'

describe 'Main Security Group' do
  let(:config_file) { File.expand_path('../../../yaml/config.yaml', __FILE__) }
  let(:config) { AwsServerspecHelpers::ConfigLoader.get_environment_config(config_file) }
  let(:security_group_helper) { AwsServerspecHelpers::SecurityGroupHelper.new(config) }
  let(:main_security_group) { security_group_helper.get_security_groups_by_tags '2017-PUPPETCONF' }

  it 'should allow incoming ssh' do
    tcp = get_by_port_from(main_security_group, 'ingress', 'from_port', 22)
    expect(tcp[:ip_protocol]).to eq('tcp')
    expect(tcp[:from_port]).to eq(22)
    expect(tcp[:to_port]).to eq(22)
    expect(tcp[:ip_ranges][0][:cidr_ip]).to eq('0.0.0.0/0')
  end

  it 'should allow all outgoing tcp' do
    tcp = get_by_port_from(main_security_group, 'egress', 'ip_protocol', 'tcp')
    expect(tcp[:ip_protocol]).to eq('tcp')
    expect(tcp[:from_port]).to eq(0)
    expect(tcp[:to_port]).to eq(65535)
    expect(tcp[:ip_ranges][0][:cidr_ip]).to eq('0.0.0.0/0')
  end

  it 'should allow incoming http' do
    tcp = get_by_port_from(main_security_group, 'ingress', 'from_port', 80)
    expect(tcp[:ip_protocol]).to eq('tcp')
    expect(tcp[:from_port]).to eq(80)
    expect(tcp[:to_port]).to eq(80)
    expect(tcp[:ip_ranges][0][:cidr_ip]).to eq('0.0.0.0/0')
  end

  # it 'should allow incoming http port 81' do
    # tcp = get_by_port_from(main_security_group, 'ingress', 'from_port', 81)
    # expect(tcp[:ip_protocol]).to eq('tcp')
    # expect(tcp[:from_port]).to eq(81)
    # expect(tcp[:to_port]).to eq(81)
    # expect(tcp[:ip_ranges][0][:cidr_ip]).to eq('0.0.0.0/0')
  # end
end
