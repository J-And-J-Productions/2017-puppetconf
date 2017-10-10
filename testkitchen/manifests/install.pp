class awsapache::install {
  class {'apache': }

  file { 'install-example1-webpage':
    ensure => file,
    path   => '/var/www/example-1/index.html',
    source => 'puppet:///modules/awsapache/example-1/index.html',
  }

}
