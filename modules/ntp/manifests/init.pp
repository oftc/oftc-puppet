class ntp {
  ensure_packages (['ntp'])

  service { 'ntp': }

  file_line { 'ntp.oftc.conf include':
    path => '/etc/ntp.conf',
    line => 'includefile /etc/ntp.oftc.conf',
    require => Package['ntp'],
    notify => Service['ntp'],
  }

  $configserverips = hiera("configserverips")
  file { '/etc/ntp.oftc.conf':
    mode => 0644, owner => root, group => root,
    content => template('ntp/ntp.oftc.conf'),
    require => Package['ntp'],
    notify => Service['ntp'],
  }
}
