class oftc::configmaster {
  include ansible
  include munin
  include smokeping
  include userdir-ldap::master
  include ::geodns

  $hosts = hiera('hosts')

  file { '/etc/oftc/acme/.domains.oftc.txt':
    mode => 0644, owner => root, group => root,
    content => template('oftc/hosts'),
  }
}
