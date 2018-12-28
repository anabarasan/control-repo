class profile::ssh_keys (
  String $private_key,
  String $public_key,
) {

  file { '/root/.ssh/id_rsa':
    ensure  => present,
    content => $private_key,
    owner   => 'root',
    group   => 'root',
    mode    => '600',
  }

  file { '/root/.ssh/id_rsa.pub':
    ensure  => present,
    content => $public_key,
    owner   => 'root',
    group   => 'root',
    mode    => '644',
  }

}