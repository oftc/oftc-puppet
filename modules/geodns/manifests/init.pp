class geodns {
  ensure_packages ([
    'bind9',
    'bind9utils',
  ])

  $bind_listen_v4 = hiera('bind_listen_v4')
  $bind_listen_v6 = hiera('bind_listen_v6')
  file { '/etc/bind/named.conf.options':
    mode => '644',
    content => template('geodns/named.conf.options'),
    require => Package['bind9'],
    notify => Service['bind9'],
  }

  $geodns_keys = hiera('geodns_keys')
  file { '/etc/bind/geodns.keys':
    mode => '440', owner => bind, group => bind,
    content => template('geodns/geodns.keys'),
    require => Package['bind9'],
    notify => Service['bind9'],
  }

  file { '/etc/bind/continents.acl':
    mode => '644',
    content => template('geodns/continents.acl'),
    require => Package['bind9'],
    notify => Service['bind9'],
  }

  $dns_masters = hiera('dns_masters')
  file { '/etc/bind/named.conf.geodns':
    mode => '644',
    content => template('geodns/named.conf.geodns'),
    require => Package['bind9'],
    notify => Service['bind9'],
  }

  file { '/etc/bind/named.conf':
    mode => '644',
    content => template('geodns/named.conf'),
    require => Package['bind9'],
    notify => Service['bind9'],
  }

  file { '/usr/local/bin/geodns-fetch':
    mode => '755',
    content => template('geodns/geodns-fetch'),
  }

  file { '/etc/cron.weekly/geodns-fetch':
    ensure => link,
    target => '/usr/local/bin/geodns-fetch',
  }

  service { 'bind9': }
}
