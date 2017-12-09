class syslog_ng {
  ensure_packages (['syslog-ng'])

  service { 'syslog-ng': }

  file { '/etc/syslog-ng/conf.d/oftc.conf':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/syslog_ng/oftc.conf",
    require => Package['syslog-ng'],
    notify => Service['syslog-ng'],
  }

  if $::hostname in hiera('vservers') {
    file_line { 'disable /proc/kmsg':
      path => '/etc/syslog-ng/syslog-ng.conf',
      line => '       unix-stream("/dev/log"); # system() but without /proc/kmsg',
      match => '^       .*system\(\)',
      require => Package['ntp'],
      notify => Service['ntp'],
    }
  }
}
