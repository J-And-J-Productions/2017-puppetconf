require_relative 'spec_helper'

describe '2017-PUPPETCONF Web Server' do
  let(:config_file) { File.expand_path('../../../yaml/config.yaml', __FILE__) }
  let(:config) { AwsServerspecHelpers::ConfigLoader.get_environment_config(config_file) }
  let(:ec2_instance_helper) { AwsServerspecHelpers::EC2InstanceHelper.new config }
  let(:subnet_helper) { AwsServerspecHelpers::SubnetHelper.new(config) }
  let(:found_instances) { ec2_instance_helper.get_instance_details_by_tags '2017-PUPPETCONF' }
  let(:found_subnets) { subnet_helper.get_subnet_details_by_tag ['2017-PUPPETCONF'] }
  let(:security_group_helper) { AwsServerspecHelpers::SecurityGroupHelper.new(config) }
  let(:main_security_group) { security_group_helper.get_security_groups_by_tags '2017-PUPPETCONF' }

  it 'Should find one webserver' do
    expect(found_instances.size).to be(1)
  end

  it 'should be in one of the sample subnets we set up' do
    instance_subnets = found_instances.map { |instance| instance[:instances][0][:subnet_id] }
    subnet_ids = found_subnets.map { |subnet| subnet[:subnet_id] }
    expect(subnet_ids).to include(*instance_subnets)
  end

  it 'should be ec2 instance type t2.micro' do
    instance_types = found_instances.map {|instance| instance[:instances][0][:instance_type]}
    expect(instance_types).to all(eq('t2.micro'))
  end

  it 'should use the correct ami' do
    image_ids = found_instances.map {|instance| instance[:instances][0][:image_id]}
    expect(image_ids).to all(eq('ami-cb1d41b0'))
  end

  it 'should have the right security groups applied' do
    actual_security_groups = found_instances.flat_map { |instance| get_security_groups_from_ec2_instance(instance[:instances][0]) }
    expect(actual_security_groups).to match_array(['main'])
  end
end

