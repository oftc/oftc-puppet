class munin::node {
  ensure_packages ([
    'munin-node',
    'libnet-ssleay-perl',
  ])

  service { 'munin-node':
    ensure => running,
    enable => true,
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

  file_line { 'tls enabled':
    path => '/etc/munin/munin-node.conf',
    line => 'tls enabled',
    match => '^tls ',
    require => Package['munin-node'],
    notify => Service['munin-node'],
  }
  file_line { 'tls_verify_certificate no':
    path => '/etc/munin/munin-node.conf',
    line => 'tls_verify_certificate no',
    match => '^tls_verify_certificate ',
    require => Package['munin-node'],
    notify => Service['munin-node'],
  }
  file_line { 'tls_ca_certificate /etc/ssl/certs/thishost.pem':
    path => '/etc/munin/munin-node.conf',
    line => 'tls_ca_certificate /etc/ssl/certs/thishost.pem',
    match => '^tls_ca_certificate ',
    require => Package['munin-node'],
    notify => Service['munin-node'],
  }
  file_line { 'tls_private_key /etc/ssl/private/thishost.key':
    path => '/etc/munin/munin-node.conf',
    line => 'tls_private_key /etc/ssl/private/thishost.key',
    match => '^tls_private_key ',
    require => Package['munin-node'],
    notify => Service['munin-node'],
  }
  file_line { 'tls_certificate /etc/ssl/certs/thishost.pem':
    path => '/etc/munin/munin-node.conf',
    line => 'tls_certificate /etc/ssl/certs/thishost.pem',
    match => '^tls_certificate ',
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
