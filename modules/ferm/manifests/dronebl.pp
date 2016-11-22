class ferm::dronebl {

  file { '/var/lib/dronebl':
    owner => root, group => root, mode => '0755',
    ensure => directory,
  }

  # v4
  file { '/var/lib/dronebl/dronebl4':
    owner => root, group => root, mode => '0644',
    source => 'puppet:///files/dronebl4',
    backup => false,
    show_diff => false,
    notify => Exec['ipset-load dronebl4'],
  }

  exec { 'ipset-load dronebl4':
    command => '/usr/local/sbin/ipset-load dronebl4 "hash:net family inet" /var/lib/dronebl/dronebl4',
    refreshonly => true,
    require => File['/usr/local/sbin/ipset-load'],
  }

  # v6
  file { '/var/lib/dronebl/dronebl6':
    owner => root, group => root, mode => '0644',
    source => 'puppet:///files/dronebl6',
    backup => false,
    show_diff => false,
    notify => Exec['ipset-load dronebl6'],
  }

  exec { 'ipset-load dronebl6':
    command => '/usr/local/sbin/ipset-load dronebl6 "hash:net family inet6" /var/lib/dronebl/dronebl6',
    refreshonly => true,
    require => File['/usr/local/sbin/ipset-load'],
  }

}
