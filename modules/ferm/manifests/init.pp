class ferm {
  ensure_packages(['ferm'])

  $forward_policy = hiera('forward_policy', 'DROP')
  $ircports_public = hiera('ircports_public')
  $ircports_private = hiera('ircports_private')
  $oftchosts = hiera('oftchosts')
  $oftcaccounts = hiera('oftcaccounts')
  $admin_ip4 = hiera_array('admin_ip4')
  $admin_ip6 = hiera_array('admin_ip6')
  $staff_ip4 = hiera_array('staff_ip4')
  $staff_ip6 = hiera_array('staff_ip6')
  $badguys_ip4 = hiera_array('badguys_ip4')
  $badguys_ip6 = hiera_array('badguys_ip6')

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
  ferm::port { 'ssh':
    target => 'jump STAFF',
  }

  # REJECT everything else (instead of applying the DROP default)
  # but honor this node's forward_policy
  $forward_final = $forward_policy ? {
    'ACCEPT' => 'ACCEPT',
    default  => 'REJECT',
  }
  concat::fragment { "ferm.conf.foot":
    target => '/etc/ferm/ferm.conf',
    order => 99,
    content => template('ferm/ferm.conf.foot'),
  }

  service { 'ferm':
    hasstatus => false,
    status => '/bin/true',
  }

  # remove old service
  file { [
    '/etc/default/local-firewall', '/etc/init.d/local-firewall',
    '/etc/rc0.d/K01local-firewall', '/etc/rc1.d/K01local-firewall',
    '/etc/rc2.d/S01local-firewall', '/etc/rc3.d/S01local-firewall',
    '/etc/rc4.d/S01local-firewall', '/etc/rc5.d/S01local-firewall',
    '/etc/rc6.d/K01local-firewall'
  ]:
    ensure => absent,
  }

  file { '/etc/ferm/Makefile':
    owner => root, group => root, mode => '0644',
    content => template('ferm/Makefile'),
    require => Package['ferm'],
    notify => Service['ferm'],
  }

}
