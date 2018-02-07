class syslog_ng::loghost {
  file { '/etc/syslog-ng/conf.d/remote.conf':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/syslog_ng/remote.conf",
    require => Package['syslog-ng'],
    notify => Service['syslog-ng'],
  }

  file { '/etc/cron.daily/syslog-ng-remote':
    mode => '0755', owner => root, group => root,
    source => "puppet:///modules/syslog_ng/syslog-ng-remote.daily",
  }

  file { '/usr/local/bin/check_remote_logging':
    mode => '0755', owner => root, group => root,
    source => "puppet:///modules/syslog_ng/check_remote_logging",
  }

  file { '/etc/sudoers.d/remote_logging':
    mode => '0400', owner => root, group => root,
    content => "nagios ALL=(ALL) NOPASSWD: /usr/local/bin/check_remote_logging\n",
    require => Package['sudo'],
  }

  ferm::port { 'syslogs':
    port => '1514',
  }
}
