class smokeping {
  ensure_packages ([
    'smokeping',
  ])

  $hosts = hiera('hosts')
  file { '/etc/smokeping/config.d/oftc':
    mode => 0644, owner => root, group => root,
    content => template('smokeping/oftc'),
    require => Package['smokeping'],
    notify => Service['smokeping'],
  }

  service { 'smokeping': }
}
