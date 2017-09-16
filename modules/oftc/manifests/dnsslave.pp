class oftc::dnsslave {

  ensure_packages(['bind9'])

  file { '/etc/bind/named.conf':
    mode => '0644', owner => root, group => root,
    content => template('oftc/named.conf'),
    require => Package['bind9'],
    notify => Service['bind9'],
  }

  $bind_listen_v4 = hiera('bind_listen_v4')
  $bind_listen_v6 = hiera('bind_listen_v6')
  file { '/etc/bind/named.conf.options':
    mode => '644',
    content => template('geodns/named.conf.options'),
    require => Package['bind9'],
    notify => Service['bind9'],
  }

  $dns_masters = hiera('dns_masters')
  file { '/etc/bind/named.conf.local':
    mode => '644',
    content => template('oftc/named.conf.local'),
    require => Package['bind9'],
    notify => Service['bind9'],
  }

  service { 'bind9': }
}
