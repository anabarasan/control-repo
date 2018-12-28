class role::master {
  include profile::puppetdb
  include profile::puppetboard
  include profile::ssh_keys

  Class['profile::puppetdb'] -> Class['profile::puppetboard']
}