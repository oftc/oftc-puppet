class oftc::configmaster {
  include ansible
  include munin
  include smokeping
  include userdir-ldap::master
  include ::geodns

  $oftchosts = hiera('oftchosts')

  file { '/etc/oftc/acme/.domains.oftc.txt':
    mode => 0644, owner => root, group => root,
    content => template('oftc/hosts'),
  }

  include oftc::domain

  # accept mail for db.oftc.net
  ferm::port { 'smtp':
    target => 'ACCEPT',
  }
}
