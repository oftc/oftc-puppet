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

  service { 'ssh':
    ensure => running,
    enable => true,
  }

  augeas { 'ssh_config':
    context => "/files/etc/ssh/ssh_config",
    changes => [
      'set Host/HashKnownHosts no',
    ],
    require => Package['openssh-client'],
  }
}
