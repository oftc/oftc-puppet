class oftc::cert {
  ensure_packages['ca-certificates']

  file { "/etc/ssl/certs/thishost-chained.pem":
    ensure => link,
    target => "$::hostname.oftc.net-chained.pem",
    require => Package['ca-certificates'],
  }

  file { "/etc/ssl/certs/thishost.pem":
    ensure => link,
    target => "thishost-chained.pem",
    require => Package['ca-certificates'],
  }

  file { "/etc/ssl/private/thishost.key":
    ensure => link,
    target => "$::hostname.oftc.net.key",
    require => Package['ca-certificates'],
  }
}
