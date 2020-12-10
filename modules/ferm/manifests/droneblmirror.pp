class ferm::droneblmirror {

  user { 'dronebl':
    system => true,
    home => '/var/cache/dronebl',
  }

  $droneblrsync = hiera('droneblrsync')
  file { '/etc/oftc/dronebl.rsyncpw':
    owner => root, group => dronebl, mode => '0640',
    content => "$droneblrsync\n",
  }

  file { '/usr/local/bin/sort_and_combine_addresses':
    owner => root, group => root, mode => '0755',
    source => "puppet:///modules/ferm/sort_and_combine_addresses.py",
  }

  file { '/etc/cron.hourly/dronebl-download':
    owner => root, group => root, mode => '0755',
    content => template('ferm/dronebl-download'),
  }
}
