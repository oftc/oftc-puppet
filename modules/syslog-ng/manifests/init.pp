class syslog-ng {
  ensure_packages ['syslog-ng']

  service { 'syslog-ng': }

  if !($::hostname == hiera('loghost')) {
    file { '/etc/syslog-ng/conf.d/oftc.conf':
      mode => 0644, owner => root, group => root,
      source => "puppet:///modules/syslog-ng/oftc.conf",
      require => Package['syslog-ng'],
      notify => Service['syslog-ng'],
    }
  }
}
