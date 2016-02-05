class acme_tiny {
  ensure_packages ([
    'apache2',
    'openssl',
  ])

  file { '/usr/bin/acme_tiny':
    source => "puppet:///modules/acme_tiny/acme_tiny.py",
    mode => 0755, owner => root, group => root,
  }

  file { '/etc/acme':
    ensure => directory,
    mode => '0700',
  }

  file { '/etc/acme/lets-encrypt-x1-cross-signed.pem':
    source => "puppet:///modules/acme_tiny/lets-encrypt-x1-cross-signed.pem",
    mode => 0644, owner => root, group => root,
  }

  exec { '/etc/acme/account.key':
    command => '/bin/sh -c "umask 077; openssl genrsa 4096 > /etc/acme/account.key"',
    creates => '/etc/acme/account.key',
    require => [
      Package['openssl'],
      File['/etc/acme'],
    ],
  }

  file { '/var/www/acme':
    ensure => directory,
    require => Package['apache2'],
  }

  file { '/etc/apache2/conf-available/acme.conf':
    source => "puppet:///modules/acme_tiny/acme.conf.apache2",
    mode => 0755, owner => root, group => root,
  }

  file { '/etc/cron.monthly/acme':
    source => "puppet:///modules/acme_tiny/acme.cron.monthly",
    mode => 0755, owner => root, group => root,
    require => Package['cron'],
  }

}
