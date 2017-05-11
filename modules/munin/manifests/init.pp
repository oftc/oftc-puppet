class munin {
  ensure_packages ([
    'munin',
  ])

  $oftchosts = hiera('oftchosts')
  $ircservers = hiera('ircservers')
  file { '/etc/munin/munin.conf':
    mode => '0644', owner => root, group => root,
    content => template('munin/munin.conf'),
    require => Package['munin'],
  }

  $ircservers.each |String $host| {
    munin::plugin { "irc_$host.oftc.net":
      directory => '/usr/local/oftc-tools/infrastructure/munin',
      plugin => 'irc_',
    }
  }
}
