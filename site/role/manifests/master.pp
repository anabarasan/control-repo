# class role::master
class role::master {
  include profile::puppetdb
  include profile::puppetboard
  include profile::ssh_keys
  # include profile::agents

  Class['profile::puppetdb'] -> Class['profile::puppetboard']
}