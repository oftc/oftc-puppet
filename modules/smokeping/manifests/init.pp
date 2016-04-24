class smokeping {
  ensure_packages ([
    'fping',
    'smokeping',
  ])

  $oftchosts = hiera('oftchosts')
  $smokepingslaves = hiera('smokepingslaves')
  file { '/etc/smokeping/config.d/Targets':
    mode => "0644", owner => root, group => root,
    content => template('smokeping/Targets'),
    require => Package['smokeping'],
    notify => Service['smokeping'],
  }

  file { '/etc/smokeping/config.d/Probes':
    mode => "0644", owner => root, group => root,
    content => template('smokeping/Probes'),
    require => Package['smokeping'],
    notify => Service['smokeping'],
  }

  # fix Debian #760945
  file { '/etc/smokeping/smokeping_secrets':
    mode => "0640", owner => smokeping, group => "www-data",
  }

  service { 'smokeping': }
}
