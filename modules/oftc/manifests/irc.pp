class oftc::irc {
  ensure_packages ([
    'build-essential',
    'bison',
    'flex',
    'zlib1g-dev',
    'libssl-dev',
  ])

  file { '/etc/security/limits.d/oftc_limits.conf':
    mode => 0644, owner => root, group => root,
    source => "puppet:///modules/oftc/oftc_limits.conf",
  }

  munin::plugin {[
    'irc',
    'ircmemory',
  ]:
    directory => '/usr/local/oftc-tools/infrastructure/munin',
  }

  file { '/etc/munin/plugin-conf.d/ircmemory':
    ensure => link,
    target => '/usr/local/oftc-tools/infrastructure/munin/plugin-conf.d/ircmemory',
    require => Package['munin-node'],
    notify => Service['munin-node'],
  }
}
