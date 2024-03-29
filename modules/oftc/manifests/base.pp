class oftc::base {

  # yes, this is really how you convert a string to a number in puppet
  if (0 + $facts['os']['distro']['release']['major']) >= 11 {
    $dnsutils = "bind9-dnsutils"
    $locate = "plocate"
    $wireguard = "wireguard-tools"
  } else {
    $dnsutils = "dnsutils"
    $locate = "mlocate"
    $wireguard = "perl" # Yes this is a hack, I know.
  }

  ensure_packages ([
    'at',
    'binutils', # for strings in the running kernel check
    'conntrack', # for munin/check_conntrack
    'cron',
    'deborphan',
    'dialog', # for deborphan's orphaner
    $dnsutils, # for nslookup/check_dns
    'etckeeper',
    'git',
    'htop',
    'iptables',
    'less',
    'locales-all',
    $locate,
    'logrotate',
    'lsb-release',
    'man-db',
    'molly-guard',
    'mtr-tiny',
    'ncdu',
    'ntp',
    'psmisc',
    'ssl-cert',
    'strace',
    'sudo',
    'sysstat',
    'tree',
    'vim',
    $wireguard,
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

  # root directory for all user homes
  file { '/home/oftc':
    mode => '0755', owner => root, group => root,
    ensure => directory,
  }
}
