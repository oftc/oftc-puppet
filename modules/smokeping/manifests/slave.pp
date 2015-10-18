class smokeping::slave {
  ensure_packages ([
    'fping',
    'smokeping',
  ])

  $master = hiera('configserver')
  file { '/etc/default/smokeping':
    mode => "0644", owner => root, group => root,
    content => template('smokeping/slave.default'),
    require => Package['smokeping'],
    notify => Service['smokeping'],
  }

  service { 'smokeping': }
}

