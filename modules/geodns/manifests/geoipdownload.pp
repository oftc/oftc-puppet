class geodns::geoipdownload {

  user { 'geoip':
    system => true,
    home => '/var/cache/GeoIP',
    managehome => true,
  }

  file { '/etc/cron.weekly/geoip-update':
    owner => root, group => root, mode => '0755',
    source => 'puppet:///modules/geodns/geoip-update',
  }
}
