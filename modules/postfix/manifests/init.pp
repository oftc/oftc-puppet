class postfix {
  ensure_packages [
    'postfix',
    'postfix-cdb',
  ]

  service { 'postfix': }

  file { '/etc/postfix/main.cf':
    mode => 0644, owner => root, group => root,
    source => "puppet:///modules/postfix/main.cf",
    require => Package['postfix'],
    notify => Service['postfix'],
  }

  file { '/etc/postfix/master.cf':
    mode => 0644, owner => root, group => root,
    source => "puppet:///modules/postfix/master.cf",
    require => Package['postfix'],
    notify => Service['postfix'],
  }

}
