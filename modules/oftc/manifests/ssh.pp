class oftc::ssh {
  ensure_packages ['openssh-server', 'openssh-client']

  augeas { 'sshd_config':
    context => "/files/etc/ssh/sshd_config",
    changes => [
      'set PermitRootLogin without-password',
    ],
    require => Package['openssh-server']
  }

  augeas { 'ssh_config':
    context => "/files/etc/ssh/ssh_config",
    changes => [
      'set Host/HashKnownHosts no',
    ],
    require => Package['openssh-client']
  }
}
