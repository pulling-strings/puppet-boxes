# Setting up an nginx based sandbox serving machine
class boxes($keys = []){

  include ::boxes::nginx

  file{'/var/boxes':
    ensure => directory,
  } -> Class[::Boxes::Nginx]

  if($::virtual == 'docker'){
    include runit
  }

  if($keys != []){
    file{'/root/.ssh/':
      ensure => directory,
    } -> Ssh_Authorized_Key<||>

    $defaults = {
      user => 'root'
    }
      
    create_resources(ssh_authorized_key, $keys, $defaults)
  }
}
