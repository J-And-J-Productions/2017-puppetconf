require_relative 'spec_helper'

describe '2017-08-AWS-MEETUP Subnets' do
  # We retrieve subnets based on tags so we can pull back all subnets of a "type" and test things like
  # proper distribution across availability zones
  let(:config_file) { File.expand_path('../../../yaml/config.yaml', __FILE__) }
  let(:config) { AwsServerspecHelpers::ConfigLoader.get_environment_config(config_file) }
  let(:subnet_helper ) { AwsServerspecHelpers::SubnetHelper.new(config) }
  let(:found_subnets) { subnet_helper.get_subnet_details_by_tag '2017-08-AWS-MEETUP' }
  let(:expected_subnet_count) { 2 }

  it 'should find two subnets tagged 2017-08-AWS-MEETUP' do
    expect(found_subnets.size).to be(expected_subnet_count)
  end

  it 'should all be in different availability zones' do
    found_availability_zones = found_subnets.map { |subnet| subnet[:availability_zone] }
    expect(found_availability_zones.uniq.size).to be(expected_subnet_count)
  end

  it 'should have the correct cidr blocks assigned to the subnets' do
    found_cidrs = found_subnets.map { |subnet| subnet[:cidr_block] }
    expect(found_cidrs).to match_array(config[:main_subnet_cidrs])
  end
end
