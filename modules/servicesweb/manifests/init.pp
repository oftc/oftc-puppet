class servicesweb (
  $host,
  $pghost = '',
  $pgport = 5432,
  $servicesweb_pass,
  $servicesweb_tokensecret,
  $servicesweb_recaptcha_sitekey,
  $servicesweb_recaptcha_secretkey,
) {

  ensure_packages([
    'nodejs',
    'npm',
  ])

  user { 'servicesweb':
    home => '/home/oftc/servicesweb',
    system => true,
    managehome => true,
    shell => '/bin/bash',
  }

  exec { 'oftc-servicesweb.git':
    command => '/usr/bin/git clone https://github.com/oftc/oftc-servicesweb.git',
    cwd => '/home/oftc/servicesweb',
    user => servicesweb,
    creates => '/home/oftc/servicesweb/oftc-servicesweb',
  }

  file { '/home/oftc/servicesweb/oftc-servicesweb/server/config.js':
    mode => '0400', owner => servicesweb, group => servicesweb,
    content => template('servicesweb/config.js'),
    require => Exec['oftc-servicesweb.git'],
    notify => Service['servicesweb'],
  }

  exec { 'npm install servicesweb':
    command => '/usr/bin/npm install',
    cwd => '/home/oftc/servicesweb/oftc-servicesweb',
    user => servicesweb,
    creates => '/home/oftc/servicesweb/oftc-servicesweb/node_modules',
    require => Package['npm'],
    notify => Service['servicesweb'],
  }

  file { '/etc/systemd/system/servicesweb.service':
    mode => '0644', owner => root, group => root,
    content => template('servicesweb/servicesweb.service'),
    notify => Exec['systemctl daemon-reload'],
  }

  service { 'servicesweb':
    enable => true,
    require => [
      File['/etc/systemd/system/servicesweb.service'],
      Exec['oftc-servicesweb.git'],
      Exec['npm install servicesweb'],
    ],
  }
}
