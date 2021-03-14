class smokeping::slave {
  ensure_packages ([
    'fping',
    'smokeping',
  ])

  $master = hiera('configserver')
  file { '/etc/systemd/system/smokeping.service.d/override.conf':
    mode => "0644", owner => root, group => root,
    content => template('smokeping/override.conf'),
    require => Package['smokeping'],
    notify => Service['smokeping'],
  }

  service { 'smokeping': }
}

