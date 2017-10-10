class awsapache::resources::vhosts (
  $vhosts = $awsapache::params::vhosts,
) inherits ::awsapache::params {
  notify {"vhost_hash: ${vhosts}": }
  create_resources(apache::vhost, $vhosts)
}
