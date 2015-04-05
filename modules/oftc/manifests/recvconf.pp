class oftc::recvconf {
  file { '/etc/oftc':
    mode => 0755, owner => root, group => root,
    ensure => directory,
  }

  file { '/etc/oftc/recvconf.files':
    mode => 0644, owner => root, group => root,
    source => "puppet:///modules/oftc/recvconf.files",
    require => File['/etc/oftc'],
  }

  file { '/usr/local/sbin/recvconf':
    mode => 0755, owner => root, group => root,
    source => "puppet:///modules/oftc/recvconf",
  }
}
