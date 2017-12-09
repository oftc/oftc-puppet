class oftc::loghost {
  file { '/etc/syslog-ng/conf.d/remote.conf':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/oftc/syslog-ng-remote.conf",
    require => Package['syslog-ng'],
    notify => Service['syslog-ng'],
  }

  $expire_logs = 90;
  file { '/etc/cron.daily/syslog-ng-remote':
    mode => '0755', owner => root, group => root,
    content => "#!/bin/sh\nfind /var/log/hosts -type f -mtime +$expire_logs -delete\n",
  }

  ferm::port { 'syslogs':
    port => '1514',
  }
}
