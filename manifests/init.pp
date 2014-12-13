# Setting up an nginx based sandbox serving machine
class boxes(
  $keys = []
){
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

    if($keys != []){
      file{'/root/.ssh/':
        ensure => directory,
      } ->

      file { '/root/.ssh/authorized_keys':
        ensure  => file,
        mode    => '0644',
        content => template('boxes/authorized_keys.erb'),
        owner   => root,
        group   => root,
      }
    }
  }
}
