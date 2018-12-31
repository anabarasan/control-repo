# Class: profile::puppetboard
#
# Puppetboard is a WebUI to inspect PuppetDB
#
class profile::puppetboard {

  include ::apache

  $puppetboard_certname = $trusted['certname']
  $ssl_dir = '/etc/puppetlabs/puppet/ssl'
  $puppetboard_host = 'puppetboard.example.com'

  host { $puppetboard_host:
    ip => '127.0.0.1'
  }

  class { '::puppetboard':
    user                => 'puppet',
    groups              => 'puppet',
    manage_git          => true,
    manage_virtualenv   => true,
    manage_selinux      => false,
    puppetdb_host       => $puppetboard_certname,
    puppetdb_port       => 8081,
    reports_count       => 40,
    enable_catalog      => true,
    puppetdb_key        => "${ssl_dir}/private_keys/${puppetboard_certname}.pem",
    puppetdb_ssl_verify => "${ssl_dir}/certs/ca.pem",
    puppetdb_cert       => "${ssl_dir}/certs/${puppetboard_certname}.pem",
    listen              => 'public',
    default_environment => '*',
  }

  class { '::apache::mod::wsgi':
    wsgi_socket_prefix => '/var/run/wsgi',
  }

  class { '::puppetboard::apache::vhost':
    user       => 'puppet',
    group      => 'puppet',
    vhost_name => $puppetboard_host,
    port       => 80,
  }
}