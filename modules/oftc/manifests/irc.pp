class oftc::irc {

  # oftc-hybrid is not yet compatible with openssl 1.1
  if $::lsbdistcodename == "stretch" {
    $libssl_dev = "libssl1.0-dev"
  } else {
    $libssl_dev = "libssl-dev"
  }

  ensure_packages ([
    'build-essential',
    'gdb',
    'bison',
    'flex',
    'zlib1g-dev',
    $libssl_dev,
    # building from git:
    'automake',
    'libltdl-dev',
    'libtool',
  ])

  file { '/etc/security/limits.d/oftc_limits.conf':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/oftc/oftc_limits.conf",
  }

  file { '/etc/systemd/system/user@10100.service.d':
    ensure => directory,
    mode => '0644', owner => root, group => root,
  }

  file { '/etc/systemd/system/user@10100.service.d/limits.conf':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/oftc/oftc_systemd_limits.conf",
  }

  file_line { '/etc/ssl/openssl.cnf: MinProtocol':
    path  => '/etc/ssl/openssl.cnf',
    line  => 'MinProtocol = None',
    match => '^MinProtocol',
  }

  file_line { '/etc/ssl/openssl.cnf: CipherString':
    path  => '/etc/ssl/openssl.cnf',
    line  => 'CipherString = DEFAULT',
    match => '^CipherString',
  }

  munin::plugin {[
    'irc',
    'ircmemory',
  ]:
    directory => '/usr/local/oftc-tools/infrastructure/munin',
  }

  file { '/etc/munin/plugin-conf.d/ircmemory':
    ensure => link,
    target => '/usr/local/oftc-tools/infrastructure/munin/plugin-conf.d/ircmemory',
    require => Package['munin-node'],
    notify => Service['munin-node'],
  }

  munin::plugin { 'ircsyn':
    content => template('oftc/ircsyn.munin'),
    conf => "user root",
  }

  # init/oftc_user are custom facts from facts.d/oftc
  if ($init == 'systemd') {
    ensure_packages (['libpam-systemd'])

    # needs first ud-replicate run for the user to exist
    if ($oftc_user == 'true') {
      exec { 'enable-linger-oftc':
        command => '/bin/loginctl enable-linger oftc',
        creates => '/var/lib/systemd/linger/oftc',
      }
    }
  }
  if ($oftc_user == 'true') {
    # hack: make sure webirc can read the hybrid certificate
    file { '/home/oftc/oftc':
      ensure => directory,
      owner => oftc, group => oftc, mode => '2755',
    }

    $oftckey = hiera('oftckey')
    ssh_authorized_key { 'OFTC Infrastructure 2006-04-25 - support@oftc.net':
      user => 'oftc',
      type => 'ssh-rsa',
      key => $oftckey,
      require => File['/home/oftc/oftc'],
    }
  }

  # ansible facts
  file { '/etc/ansible':
    ensure => directory,
  }

  file { '/etc/ansible/facts.d':
    ensure => directory,
    require => File['/etc/ansible'],
  }

  file { '/etc/ansible/facts.d/oftc.fact':
    mode => '0644', owner => root, group => root,
    content => template('oftc/oftc.fact'),
    require => File['/etc/ansible/facts.d'],
  }

  # firewall
  ferm::port { 'irc_private':
    sequence => 30,
    port => hiera('ircports_private'),
    target => 'jump STAFF',
  }

  include ferm::dronebl

  ferm::port { 'irc':
    sequence => 50,
    port => hiera('ircports_public'),
    target => 'ACCEPT',
  }

}
