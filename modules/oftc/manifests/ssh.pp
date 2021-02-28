class oftc::ssh {
  ensure_packages (['openssh-server', 'openssh-client'])

  augeas { 'sshd_config':
    context => "/files/etc/ssh/sshd_config",
    changes => [
      'set PermitRootLogin without-password',
      'set AuthorizedKeysFile "%h/.ssh/authorized_keys /etc/ssh/userkeys/%u /var/lib/misc/userkeys/%u"',
    ],
    require => Package['openssh-server'],
    notify => Service['ssh'],
  }

  file { '/etc/ssh/userkeys':
    ensure => directory,
  }

  $rootkeys = hiera_array("rootkeys")
  file { '/etc/ssh/userkeys/root':
    mode => '0600', owner => root, group => root,
    content => template('oftc/userkeys.root'),
    require => File['/etc/ssh/userkeys'],
  }

  service { 'ssh':
    ensure => running,
    enable => true,
  }
}
