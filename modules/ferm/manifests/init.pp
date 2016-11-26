class ferm {
  ensure_packages(['ferm', 'ipset'])

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

  ferm::port { 'ssh':
    sequence => 22,
    target => 'jump STAFF',
  }
  ferm::port { 'infrastructure':
    sequence => 25,
    port => 'smtp munin nrpe',
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

  # ipset

  file { '/usr/local/sbin/ipset-load':
    owner => root, group => root, mode => '0755',
    content => template('ferm/ipset-load'),
  }

  file { '/etc/ipset':
    owner => root, group => root, mode => '0755',
    ensure => directory,
  }

  ferm::ipset { 'staff4': family => 'inet',  list => $staff_ip4, }
  ferm::ipset { 'staff6': family => 'inet6', list => $staff_ip6, }

  ferm::ipset { 'admin4': family => 'inet',  list => $admin_ip4, }
  ferm::ipset { 'admin6': family => 'inet6', list => $admin_ip6, }

  ferm::ipset { 'badguys4': family => 'inet',  list => $badguys_ip4, }
  ferm::ipset { 'badguys6': family => 'inet6', list => $badguys_ip6, }

  $oftc_all = concat($oftchosts, $oftcaccounts)
  $oftc4 = $oftc_all.map |$host| { $host['ip4'] }
  $oftc6 = $oftc_all.map |$host| { $host['ip6'] }
  ferm::ipset { 'oftc4': family => 'inet',  list => $oftc4, }
  ferm::ipset { 'oftc6': family => 'inet6', list => $oftc6, }

}
