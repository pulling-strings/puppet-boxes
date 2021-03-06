# Setting up an nginx based sandbox serving machine
class boxes(
  $keys = [],
  $user = 'root'
){

  include ::boxes::nginx
  include ::boxes::ports

  file{'/var/boxes':
    ensure => directory,
  } -> Class[::Boxes::Nginx]

  if($::virtual == 'docker'){
    include runit
  }

  if($keys != []){
    if $user == 'root' {
      file{'/root/.ssh/':
        ensure => directory,
      } -> Ssh_Authorized_Key<||>
    }
      
    create_resources(ssh_authorized_key, $keys, {user => $user})
  }
}
