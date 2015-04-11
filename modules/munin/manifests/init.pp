class munin {
  ensure_packages [
    'munin',
  ]

  $hosts = hiera('hosts')
  $ircservers = hiera('ircservers')
  file { '/etc/munin/munin.conf':
    mode => 0644, owner => root, group => root,
    content => template('munin/munin.conf'),
    require => Package['munin'],
  }

  define ircplugin {
    munin::plugin { "irc_$name.oftc.net":
      directory => '/usr/local/oftc-tools/infrastructure/munin',
      plugin => 'irc_',
    }
  }
  ircplugin { $ircservers: }
}
