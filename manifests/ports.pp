# Locking down ports
class boxes::ports {
  include ufw

  if $virtual == 'virtualbox' {
    ufw::allow { 'vagrant-ssh':
      from => 'any',
      port => 2222,
      ip   => 'any'
    }
  }

  ufw::allow { 'ssh':
    from => 'any',
    port => 22,
    ip   => 'any'
  }

  ufw::allow { 'allow-80':
    from => 'any',
    port => 80,
    ip   => 'any'
  }

  ufw::allow { 'allow-https-from-all':
    from => 'any',
    port => 443,
    ip   => 'any'
  }
}
