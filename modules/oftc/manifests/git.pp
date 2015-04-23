class oftc::git {
  ensure_packages (['git'])

  file { '/usr/local/oftc-tools':
    ensure => directory,
    notify => Exec['oftc-tools'],
  }

  exec { 'oftc-tools':
    command => '/usr/bin/git clone git://git.oftc.net/oftc-tools.git /usr/local/oftc-tools',
    refreshonly => true,
    require => Package['git'],
  }
}
