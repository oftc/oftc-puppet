class oftc::nrpe {
  ensure_packages [
    'nagios-nrpe-server',
    'nagios-plugins-basic', # monitoring-plugins-basic on jessie
    'libyaml-syck-perl', # check_puppet
    'lsof', # nagios-check-libs
  ]

  service { 'nagios-nrpe-server': }

  file { '/etc/nagios/nrpe.d/nrpe_oftc.cfg':
    ensure => link,
    target => '../nrpe_oftc.cfg',
    require => Package['nagios-nrpe-server'],
    notify => Service['nagios-nrpe-server'],
  }

  file { '/etc/nagios/nrpe.d/nrpe_oftc_config.cfg':
    mode => 0644, owner => root, group => root,
    source => "puppet:///modules/oftc/nrpe_oftc_config.cfg",
    require => Package['nagios-nrpe-server'],
    notify => Service['nagios-nrpe-server'],
  }

  file { '/etc/sudoers.d/nrpe':
    mode => 0440, owner => root, group => root,
    source => "puppet:///modules/oftc/sudoers.nrpe",
    require => Package['sudo'],
  }
}
