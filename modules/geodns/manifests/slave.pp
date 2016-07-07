class geodns::slave { # DNS slave server
  include ::geodns::common

  $bind_listen_v4 = hiera('bind_listen_v4')
  $bind_listen_v6 = hiera('bind_listen_v6')
  $dns_masters = hiera('dns_masters')
  file { '/etc/bind/named.conf':
    mode => '644',
    content => template('geodns/named.conf.slave'),
    require => Package['bind9'],
    notify => Service['bind9'],
  }
}
