class oftc::base {
  ensure_packages [
    'at',
    'less',
    'lsb-release',
    'mtr-tiny',
    'ntp',
    'psmisc',
    'subversion',
    'sudo',
    'tree',
    'ulogd',
    'vim',
    'zsh',
  ]

  file { '/etc/bash.bashrc':
    mode => 0644, owner => root, group => root,
    source => "puppet:///modules/oftc/bash.bashrc",
  }

  file_line { 'sudoers.d':
    path => '/etc/sudoers',
    line => "#includedir /etc/sudoers.d\n",
    require => Package['sudo'],
  }
}
