class oftc::puppetmaster {
  file { '/etc/cron.daily/puppetmaster':
    mode => 0755, owner => root, group => root,
    source => "puppet:///modules/oftc/puppetmaster.cron.daily",
  }
}
