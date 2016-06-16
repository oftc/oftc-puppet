class geodns::common {
  ensure_packages ([
    'bind9',
    'bind9utils',
    'geoip-database-contrib',
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

  service { 'bind9': }
}
