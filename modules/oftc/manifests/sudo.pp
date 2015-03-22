class oftc::sudo {
  ensure_packages ['sudo']

  file_line { 'sudoers.d':
    path => '/etc/sudoers',
    line => "#includedir /etc/sudoers.d\n",
    require => Package['sudo'],
  }
}
