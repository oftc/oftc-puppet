class oftc::base {
  ensure_packages ([
    'at',
    'deborphan',
    'dialog', # for deborphan's orphaner
    'less',
    'locales-all',
    'lsb-release',
    'molly-guard',
    'mtr-tiny',
    'ncdu',
    'ntp',
    'psmisc',
    'subversion',
    'sudo',
    'tree',
    'ulogd',
    'vim',
    'zsh',
  ])

  file { '/etc/bash.bashrc':
    mode => 0644, owner => root, group => root,
    source => "puppet:///modules/oftc/bash.bashrc",
  }

  file_line { 'sudoers.d':
    path => '/etc/sudoers',
    line => "#includedir /etc/sudoers.d\n",
    require => Package['sudo'],
  }

  file_line { 'root mail alias':
    path => '/etc/aliases',
    line => "root: infrastructure@oftc.net\n",
    match => "^root:",
    notify => Exec['newaliases'],
  }

  exec { 'newaliases':
    command => '/usr/bin/newaliases',
    refreshonly => true,
  }
}
