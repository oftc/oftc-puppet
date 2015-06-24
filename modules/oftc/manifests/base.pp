class oftc::base {
  ensure_packages ([
    'at',
    'binutils', # for strings in the running kernel check
    'cron',
    'deborphan',
    'dialog', # for deborphan's orphaner
    'iptables',
    'less',
    'locales-all',
    'logrotate',
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
