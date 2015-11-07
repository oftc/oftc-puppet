class geodns::common {
  ensure_packages ([
    'bind9',
    'bind9utils',
  ])

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
