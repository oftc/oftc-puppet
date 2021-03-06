class oftc::base {
  ensure_packages ([
    'at',
    'binutils', # for strings in the running kernel check
    'conntrack', # for munin/check_conntrack
    'cron',
    'deborphan',
    'dialog', # for deborphan's orphaner
    'dnsutils', # for nslookup/check_dns
    'etckeeper',
    'git',
    'htop',
    'iptables',
    'less',
    'locales-all',
    'logrotate',
    'lsb-release',
    'mlocate',
    'molly-guard',
    'mtr-tiny',
    'ncdu',
    'ntp',
    'psmisc',
    'ssl-cert',
    'strace',
    'subversion',
    'sudo',
    'sysstat',
    'tree',
    'vim',
    'zsh',
  ])

  file { '/etc/alternatives/editor':
    ensure => 'link',
    target => '/usr/bin/vim.basic',
    notify => Exec['update-alternatives editor'],
  }
  exec { 'update-alternatives editor':
    command => '/usr/bin/update-alternatives --set editor /usr/bin/vim.basic',
    refreshonly => true,
  }

  # revert to original file (we used to modify it)
  # remaining diff to original is if ... PS1 ... fi
  file { '/etc/bash.bashrc':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/oftc/bash.bashrc",
  }

  file { '/etc/profile.d/myon-profile.sh':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/oftc/myon-profile.sh",
  }

  file { '/etc/profile.d/oftc-profile.sh':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/oftc/oftc-profile.sh",
  }

  file { '/etc/cron.hourly/apt':
    mode => '0755', owner => root, group => root,
    source => "puppet:///modules/oftc/cron-apt",
    require => Package['cron'],
  }

  file_line { 'root mail alias':
    path => '/etc/aliases',
    line => "root: infrastructure@oftc.net",
    match => "^root:",
    notify => Exec['newaliases'],
  }

  exec { 'newaliases':
    command => '/usr/bin/newaliases',
    refreshonly => true,
  }

  file { '/etc/mailname':
    mode => '0644', owner => root, group => root,
  }

  # utility exec triggered from elsewhere
  exec { 'systemctl daemon-reload':
    command => '/bin/systemctl daemon-reload',
    refreshonly => true,
  }
}
