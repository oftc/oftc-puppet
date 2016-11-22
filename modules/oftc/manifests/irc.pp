class oftc::irc {
  ensure_packages ([
    'build-essential',
    'gdb',
    'bison',
    'flex',
    'zlib1g-dev',
    'libssl-dev',
    # building from git:
    'automake',
    'libltdl-dev',
    'libtool',
  ])

  file { '/etc/security/limits.d/oftc_limits.conf':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/oftc/oftc_limits.conf",
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
    $oftckey = hiera('oftckey')
    ssh_authorized_key { 'OFTC Infrastructure 2006-04-25 - support@oftc.net':
      user => 'oftc',
      type => 'ssh-rsa',
      key => $oftckey,
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
  ferm::port { 'irc':
    sequence => 50,
    port => hiera('ircports_public'),
    target => 'ACCEPT',
  }
  ferm::port { 'testnet':
    sequence => 51,
    port => hiera('ircports_private'),
    target => 'jump STAFF',
  }

  include ferm::dronebl
}
