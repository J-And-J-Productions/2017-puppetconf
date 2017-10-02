class awsapache::resources::vhosts (
  $vhosts = $awsapache::params::vhosts,
) inherits ::awsapache::params {
  create_resources(apache::vhost, $vhosts)
}
