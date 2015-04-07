class oftc::cert {
  ensure_packages['ca-certificates']

  file { "/etc/ssl/certs/thishost-chained.pem":
    ensure => link,
    target => "$::hostname.oftc.net-chained.pm",
    require => Package['ca-certificates'],
  }

  file { "/etc/ssl/certs/thishost.pem":
    ensure => link,
    target => "thishost-chained.pm",
    require => Package['ca-certificates'],
  }
}
