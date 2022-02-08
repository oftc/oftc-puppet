class oftc::configmaster {
  include ansible
  include ferm::irker
  include munin
  include smokeping
  include userdir_ldap::master
  include ::geodns

  # Let's Encrypt host list
  $oftchosts = hiera('oftchosts')
  $oftchosts.each |$host| {
    file_line { "/etc/oftc/acme/domains.txt-${host['name']}":
      path => '/etc/oftc/acme/domains.txt',
      line => "${host['name']}.oftc.net",
    }
  }

  # snotes log
  file { '/etc/logrotate.d/oftc':
    mode => '0644',
    source => "puppet:///modules/oftc/logrotate.oftc",
    require => Package['logrotate'],
  }

  # firewall rules
  include ferm::domain
  include oftc::postgresql

  # accept mail for db.oftc.net
  ferm::port { 'smtp':
    target => 'ACCEPT',
  }
}
