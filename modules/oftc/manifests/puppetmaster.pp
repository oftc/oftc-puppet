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

  # forward v4 traffic to v6 address on 8140
  ensure_packages(['openbsd-inetd', 'netcat-openbsd'])

  file { '/etc/inetd.conf':
    mode => '0644', owner => root, group => root,
    content => "${ipaddress}:8140 stream tcp nowait nobody /bin/nc nc -q0 ::1 8140\n",
    notify => Service['inetd'],
  }

  service { 'inetd': }
}
