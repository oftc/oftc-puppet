class geodns::slave {
  include ::geodns::common

  $bind_listen_v4 = hiera('bind_listen_v4')
  $bind_listen_v6 = hiera('bind_listen_v6')
  file { '/etc/bind/named.conf.options':
    mode => '644',
    content => template('geodns/named.conf.options'),
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
}
