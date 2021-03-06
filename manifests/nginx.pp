# Https with basic auth setup of nginx
class boxes::nginx(
  $certdir = '/etc/nginx/ssl',
  $key = "${::fqdn}.key",
  $crt = "${::fqdn}.crt",
  $password = 'foo'
) {
  
  file{$certdir:
    ensure => directory,
  }

  $key_gen = "openssl req -newkey rsa:2048 -nodes -keyout ${::fqdn}.key  -x509 -days 365 -out ${::fqdn}.crt -subj '/CN=${::fqdn}'"

  $chipers = 'ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv3:+EXP'

  exec {'create_self_signed_sslcert':
    command => $key_gen,
    cwd     => $certdir,
    creates => [ "${certdir}/${::fqdn}.key", "${certdir}/${::fqdn}.crt", ],
    path    => ['/usr/bin', '/usr/sbin']
  } ~> Service['nginx']


  package{'nginx':
    ensure  => present
  } ->

  file { '/etc/nginx/sites-enabled/boxes.conf':
    ensure  => file,
    mode    => '0644',
    content => template('boxes/boxes.conf.erb'),
    owner   => root,
    group   => root,
  } ->

  service{'nginx':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }

  file{'/etc/nginx/sites-enabled/default':
    ensure => absent
  } ~> Service['nginx']

  package{'apache2-utils':
    ensure  => present
  } ->

  exec{'htpasswd':
    command => "htpasswd -b -c /etc/nginx/.htpasswd admin ${password}",
    user    => 'root',
    path    => ['/usr/bin','/bin',]
  }
  
}
