class geodns::common {
  ensure_packages ([
    'bind9',
    'bind9utils',
  ])

  package { ['geoip-database-extra', 'geoip-database-contrib']:
    ensure => absent,
  }

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

  file { '/etc/bind/acl.conf':
    mode => '644',
    content => template('geodns/acl.conf'),
    require => Package['bind9'],
    notify => Service['bind9'],
  }

  file { '/etc/bind/continents.acl':
    mode => '644',
    content => template('geodns/continents.acl'),
    require => Package['bind9'],
    notify => Service['bind9'],
  }

  file { '/usr/share/GeoIP':
    ensure => directory,
    mode => '0755',
  }
  file { '/usr/share/GeoIP/GeoIP.dat':
    mode => '0644',
    source => 'puppet:///files/GeoIP.dat',
    require => Package['bind9'],
    notify => Service['bind9'],
  }
  file { '/usr/share/GeoIP/GeoIPv6.dat':
    mode => '0644',
    source => 'puppet:///files/GeoIPv6.dat',
    require => Package['bind9'],
    notify => Service['bind9'],
  }
  file { '/usr/share/GeoIP/GeoLite2-Country.mmdb':
    mode => '0644',
    source => 'puppet:///files/GeoLite2-Country.mmdb',
    require => Package['bind9'],
    notify => Service['bind9'],
  }

  service { 'bind9': }
}
