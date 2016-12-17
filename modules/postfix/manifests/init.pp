class postfix {
  ensure_packages ([
    'postfix',
    'postfix-cdb',
  ])

  service { 'postfix': }

  file { '/etc/postfix/main.cf':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/postfix/main.cf",
    require => Package['postfix'],
    notify => Service['postfix'],
  }

  file { '/etc/postfix/master.cf':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/postfix/master.cf",
    require => Package['postfix'],
    notify => Service['postfix'],
  }

  file { '/etc/postfix/sasl/smtpd.conf':
    mode => '0644', owner => root, group => root,
    content => "mech_list: LOGIN PLAIN\n",
    require => Package['postfix'],
  }

  # etckeeper ignore
  file { '/etc/postfix/.gitignore':
    mode => '0644', owner => root, group => root,
    content => "debian.db\n",
    require => [ Package['postfix'], Package['etckeeper'] ],
    notify => Exec['ignore-debian.db'],
  }

  exec { 'ignore-debian.db':
    command => '/usr/bin/git rm --cached debian.db',
    cwd => '/etc/postfix',
    refreshonly => true,
  }

}
