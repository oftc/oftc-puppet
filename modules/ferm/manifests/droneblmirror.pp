class ferm::droneblmirror {

  $droneblrsync = hiera('droneblrsync')
  file { '/etc/oftc/dronebl.rsyncpw':
    owner => root, group => root, mode => '0600',
    content => "$droneblrsync\n",
  }

  file { '/etc/cron.hourly/dronebl-download':
    owner => root, group => root, mode => '0755',
    content => template('ferm/dronebl-download'),
  }
}
