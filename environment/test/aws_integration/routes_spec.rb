require_relative 'spec_helper'

describe 'Public route table' do
  let(:config_file) { File.expand_path('../../../yaml/config.yaml', __FILE__) }
  let(:config) { AwsServerspecHelpers::ConfigLoader.get_environment_config(config_file) }
  let(:route_helper) { AwsServerspecHelpers::RouteHelper.new config }
  let(:public_route_table) { route_helper.get_route_tables_by_tags '2017-08-AWS-MEETUP' }
  let(:subnet_helper ) { AwsServerspecHelpers::SubnetHelper.new(config) }
  let(:found_subnets) { subnet_helper.get_subnet_details_by_tag '2017-08-AWS-MEETUP' }

  context 'route table associations' do
    let(:route_table_associations) { public_route_table[0][:associations] }

    it 'should find one route table with tagged 2017-08-AWS-MEETUP' do
      expect(public_route_table.size).to be(1)
    end

    it 'should be associated to our demo subnets' do
      found_subnet_ids = found_subnets.map { |subnet| subnet[:subnet_id] }
      associated_subnets = route_table_associations.map { |association| association[:subnet_id] }
      expect(associated_subnets).to match_array(found_subnet_ids)
    end
  end

  context 'routes' do
    let(:found_routes) { public_route_table[0][:routes] }
    let(:routes) { found_routes.map { |route| [route[:destination_cidr_block], route[:gateway_id]] }.to_h }

    it 'should find a default route out the internet gateway' do
      expect(routes[config[:vpc_cidr]]).to eq('local')
    end

    it 'should route local traffic within the vpc' do
      # in reality this would be configured or pulled using the aws sdk. We're going to
      # do a loose match here for demo purposes
      expect(routes['0.0.0.0/0']).to match(/igw-.+/)
    end
  end
end