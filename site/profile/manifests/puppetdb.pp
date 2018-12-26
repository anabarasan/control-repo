class profile::puppetdb {
  class { 'puppetdb':
    listen_address  => '0.0.0.0',
    manage_firewall => false,
  }
  class { 'puppetdb::master::config':
    manage_report_processor => true,
    enable_reports          => true
  }
}