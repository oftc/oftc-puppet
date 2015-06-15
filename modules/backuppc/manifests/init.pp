class backuppc {
  group { 'backuppc-remote':
    ensure => present,
    system => true,
  }

  user { 'backuppc-remote':
    home => '/var/lib/backuppc-remote',
    managehome => true,
    comment => 'Remote Backuppc User,,,',
    gid => 'backuppc-remote',
    system => true,
    require => Group['backuppc-remote'],
  }

  file { '/var/lib/backuppc-remote/.ssh':
    mode => 0700, owner => 'backuppc-remote', group => 'backuppc-remote',
    ensure => directory,
    require => User['backuppc-remote'],
  }

  $backupkey = hiera('backupkey')
  file { '/var/lib/backuppc-remote/.ssh/authorized_keys':
    mode => '0600', owner => 'backuppc-remote', group => 'backuppc-remote',
    content => "$backupkey\n",
  }

  file { '/etc/sudoers.d/backuppc-remote':
    mode => 0400, owner => root, group => root,
    content => "backuppc-remote ALL=NOPASSWD: /usr/local/bin/rsync-sender\n",
    require => Package['sudo'],
  }

  file { '/usr/local/bin/rsync-sender':
    mode => 0755, owner => root, group => root,
    content => "#!/bin/sh -f\nexec /usr/bin/rsync --server --sender $*\n",
  }
}
