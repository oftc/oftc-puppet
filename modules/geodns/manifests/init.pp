class geodns {
  include ::geodns::common

  $dns_slaves = hiera('dns_slaves')
  file { '/etc/bind/named.conf':
    mode => '644',
    content => template('geodns/named.conf.master'),
    require => Package['bind9'],
    notify => Service['bind9'],
  }
}
