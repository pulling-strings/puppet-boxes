# Setting up an nginx based sandbox serving machine
class boxes {
  class {'::nginx': }

  file{'/var/boxes':
    ensure => directory,
  } ->

  nginx::resource::vhost { $::hostname:
    ensure   => present,
    www_root => '/var/boxes/',
  }

  file{'/etc/nginx/conf.d/default.conf':
    ensure  => absent
  } ~> Service['nginx']

  if($::virtual == 'docker'){
    include runit
  }
}
