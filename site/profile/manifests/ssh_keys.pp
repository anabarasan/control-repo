# class profile::ssh_keys
class profile::ssh_keys {

  $public_key = file('/root/.ssh/id_rsa.pub')
  $splits = split($public_key, ' ')
  @@ssh_authorized_key { $::hostname:
    ensure => present,
    type   => $splits[0],
    key    => $splits[1],
    user   => 'root',
    tag    => 'ssh-key'
  }

  user { 'root':
    ensure         => present,
    purge_ssh_keys => false,
  }

  @@sshkey { $::facts['networking']['fqdn']:
    host_aliases => [$::facts['networking']['hostname'], $::facts['ec2_metadata']['public-ipv4']],
    key          => $::facts['sshecdsakey'],
    type         => 'ecdsa-sha2-nistp256',
    tag          => 'host-key'
  }

  Sshkey<<| tag == 'host-key'|>>
  Ssh_authorized_key <<| tag == 'ssh-key' |>>
}