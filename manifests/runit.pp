# Setting up runit service (mainly for docker)
class boxes::runit {
  file{'/etc/service/nginx':
    ensure => directory,
  } ->

  file{'/var/log/nginx/':
    ensure => directory,
  } ->

  file { '/etc/service/nginx/run':
    ensure => file,
    mode   => 'u+x',
    source => 'puppet:///modules/boxes/nginx_run',
    owner  => root,
    group  => root,
  }
}
