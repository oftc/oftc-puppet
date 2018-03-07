class oftc::git_daemon {
  file { '/etc/systemd/system/git-daemon.service':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/oftc/git-daemon.service",
  }

  file { '/srv/git':
    mode => '2775', owner => root, group => oftc-admin,
    ensure => directory,
  }

  service { 'git-daemon':
    enable => true,
    ensure => running,
    require => [
      File['/srv/git'],
      Package['git'],
    ],
    subscribe => File['/etc/systemd/system/git-daemon.service'],
  }

  ferm::port { 'git': }
}
