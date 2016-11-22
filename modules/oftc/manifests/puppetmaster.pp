class oftc::puppetmaster {
  include ansible

  file { '/etc/cron.daily/puppetmaster':
    mode => '0755', owner => root, group => root,
    source => "puppet:///modules/oftc/puppetmaster.cron.daily",
  }

  ferm::port { 'puppetmaster':
    port => '8140',
  }

  include ferm::droneblmirror
}
