class oftc::nrpe {
  ensure_packages ([
    'nagios-nrpe-server',
    'nagios-plugins-basic', # monitoring-plugins-basic on jessie
    'nagios-plugins-standard', # check_mailq (monitoring-plugins-standard on jessie)
    'libyaml-syck-perl', # check_puppet
    'lsof', # nagios-check-libs
  ])

  if $::lsbdistcodename == 'stretch' {
  file { '/etc/default/nagios-nrpe-server':
    mode => '0644', owner => root, group => root,
    content => "NRPE_OPTS=\"\"\n",
    notify => Service['nagios-nrpe-server'],
  }
  }

  file { '/etc/nagios/nrpe.d/nrpe_oftc.cfg':
    ensure => link,
    target => '../nrpe_oftc.cfg',
    require => Package['nagios-nrpe-server'],
    notify => Service['nagios-nrpe-server'],
  }

  $configserverips = join(hiera("configserverips"), ',')
  file { '/etc/nagios/nrpe.d/nrpe_oftc_config.cfg':
    mode => '0644', owner => root, group => root,
    content => template("oftc/nrpe_oftc_config.cfg"),
    require => Package['nagios-nrpe-server'],
    notify => Service['nagios-nrpe-server'],
  }

  file { '/etc/sudoers.d/nrpe':
    mode => '0440', owner => root, group => root,
    source => "puppet:///modules/oftc/sudoers.nrpe",
    require => Package['sudo'],
  }

  user { 'nagios':
    groups => 'ssl-cert',
    require => [
      Package['ca-certificates'],
      Package['nagios-nrpe-server'],
    ],
    notify => Service['nagios-nrpe-server'],
  }

  service { 'nagios-nrpe-server': }
}
