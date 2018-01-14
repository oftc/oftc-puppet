class oftc::configmaster {
  include ansible
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

  # firewall rules
  include ferm::domain
  include oftc::postgresql

  # accept mail for db.oftc.net
  ferm::port { 'smtp':
    target => 'ACCEPT',
  }
}
