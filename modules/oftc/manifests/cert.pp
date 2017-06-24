class oftc::cert {
  ensure_packages (['ca-certificates'])

  file { "/etc/ssl/private":
    owner => root, group => 'ssl-cert', mode => '0710',
    ensure => directory,
    require => Package['ca-certificates'],
  }

  file { "/etc/ssl/certs/thishost-chained.pem":
    ensure => link,
    target => "$::fqdn-chained.pem",
    require => Package['ca-certificates'],
  }

  file { "/etc/ssl/certs/thishost.pem":
    ensure => link,
    target => "thishost-chained.pem",
    require => Package['ca-certificates'],
  }

  file { "/etc/ssl/private/thishost.key":
    ensure => link,
    target => "$::fqdn.key",
    require => Package['ca-certificates'],
  }

  # create symlinks to snakeoil certs, can be replaced with better certs later
  exec { "/etc/ssl/private/$::fqdn.key":
    command => "/bin/ln -s ssl-cert-snakeoil.key /etc/ssl/private/$::fqdn.key",
    creates => "/etc/ssl/private/$::fqdn.key",
    require => Package['ca-certificates'],
  }

  exec { "/etc/ssl/certs/$::fqdn-chained.pem":
    command => "/bin/ln -s ssl-cert-snakeoil.pem /etc/ssl/certs/$::fqdn-chained.pem",
    creates => "/etc/ssl/certs/$::fqdn-chained.pem",
    require => Package['ca-certificates'],
  }

  # create DH parameter files
  exec { "/etc/ssl/certs/dh512":
    command => "/usr/bin/openssl dhparam -out /etc/ssl/certs/dh512 512",
    creates => "/etc/ssl/certs/dh512",
    require => Package['ca-certificates'],
  }

  exec { "/etc/ssl/certs/dh1024":
    command => "/usr/bin/openssl dhparam -out /etc/ssl/certs/dh1024 1024",
    creates => "/etc/ssl/certs/dh1024",
    require => Package['ca-certificates'],
  }
}
