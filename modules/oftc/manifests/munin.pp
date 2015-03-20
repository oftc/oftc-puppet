class oftc::munin {
  package { 'munin-node': }

  service { 'munin-node':
    ensure => running,
    status => enabled,
  }

  include stdlib
  file_line { 'allow candela ipv4':
    path => '/etc/munin/munin-node.conf',
    line => 'allow 46.4.205.36',
    after => '^allow \^::1',
    require => Package['munin-node'],
    notify => Service['munin-node'],
  }
  file_line { 'allow candela ipv6':
    path => '/etc/munin/munin-node.conf',
    line => 'allow 2a01:4f8:131:1524::42',
    after => '^allow \^::1',
    require => Package['munin-node'],
    notify => Service['munin-node'],
  }

  munin::plugin {[
    'df',
    'df_abs',
    'df_inode',
    'memory',
    'netstat',
    'processes',
  ]:}
}
