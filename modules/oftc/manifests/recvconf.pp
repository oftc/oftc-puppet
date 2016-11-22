class oftc::recvconf {
  file { '/etc/oftc':
    mode => '0755', owner => root, group => root,
    ensure => directory,
  }

  file { '/etc/oftc/recvconf.files':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/oftc/recvconf.files",
    require => File['/etc/oftc'],
  }

  file { '/usr/local/sbin/recvconf':
    mode => '0755', owner => root, group => root,
    source => "puppet:///modules/oftc/recvconf",
  }

  file { '/root/.ssh':
    mode => '0700', owner => root, group => root,
    ensure => directory,
  }

  $configserverips = join(hiera("configserverips"), ',')
  file_line { 'recvconf push key':
    path => '/root/.ssh/authorized_keys',
    line => template("oftc/pushconfig.key"),
    match => 'pushconfig@oftc',
    require => File['/root/.ssh'],
  }
}
