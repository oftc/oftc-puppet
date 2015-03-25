class oftc::irc {
  ensure_packages [
    'build-essential',
    'bison',
    'flex',
    'zlib1g-dev',
    'libssl-dev',
  ]

  file { '/etc/security/limits.d/oftc_limits.conf':
    mode => 0644, owner => root, group => root,
    source => "puppet:///modules/oftc/oftc_limits.conf",
  }
}
