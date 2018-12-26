# Class: profile::puppetboard
#
# Puppetboard is a WebUI to inspect PuppetDB
#
class profile::puppetboard {

  include ::apache

  $puppetboard_certname = $trusted['certname']
  $ssl_dir = "/etc/puppetlabs/puppet/ssl"
  notice("$puppetboard_certname is certname")
  notice("$ssl_dir ssl_dir")
  $puppetboard_host = 'puppetboard.example.com'

  host { $puppetboard_host:
    ip => '127.0.0.1'
  }

  class { '::puppetboard':
    groups              => 'root',
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
  }

  class { '::apache::mod::wsgi':
    wsgi_socket_prefix => '/var/run/wsgi',
  }

  class { '::puppetboard::apache::vhost':
    vhost_name => $puppetboard_host,
    port       => 80,
  }
}