class ferm {
  ensure_packages(['ferm'])

  $ircports_public = hiera('ircports_public')
  $ircports_private = hiera('ircports_private')
  $oftchosts = hiera('oftchosts')
  $oftcaccounts = hiera('oftcaccounts')
  $admin_ip4 = hiera_array('admin_ip4')
  $admin_ip6 = hiera_array('admin_ip6')
  $staff_ip4 = hiera_array('staff_ip4')
  $staff_ip6 = hiera_array('staff_ip6')

  concat { '/etc/ferm/ferm.conf':
    owner => root, group => root, mode => '0644',
    ensure => present,
    require => Package['ferm'],
    notify => Service['ferm'],
  }

  concat::fragment { "ferm.conf":
    target => '/etc/ferm/ferm.conf',
    order => 1,
    content => template('ferm/ferm.conf'),
  }

  ferm::port { 'infrastructure':
    port => 'smtp munin nrpe',
  }
  ferm::port { 'ntp':
    proto => 'udp',
  }
  ferm::port { 'ssh':
    target => 'jump STAFF',
  }

  concat::fragment { "ferm.conf.foot":
    target => '/etc/ferm/ferm.conf',
    order => 99,
    content => "\n# ferm.conf.foot\ndomain (ip ip6) chain (INPUT FORWARD) REJECT;\n",
  }

  service { 'ferm':
    hasstatus => false,
    status => '/bin/true',
  }

  file { '/etc/ferm/Makefile':
    owner => root, group => root, mode => '0644',
    content => template('ferm/Makefile'),
    require => Package['ferm'],
    notify => Service['ferm'],
  }

}
