class onion_service {
  ensure_packages (['tor'])

  service { 'tor':
    ensure => running,
    enable => true,
  }

  file { '/etc/tor/torrc':
    mode => '0644', owner => root, group => root,
    content => template('onion_service/torrc'),
    notify => Service['tor'],
}
