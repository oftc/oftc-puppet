class jenkins {
  file { '/etc/apt/keyrings/jenkins.asc':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/jenkins/jenkins.asc", # get current file from https://pkg.jenkins.io/debian/
    require => File['/etc/apt/keyrings'],
  }

  file { '/etc/apt/trusted.gpg.d/jenkins-ci.org.asc':
    ensure => absent,
  }

  file { '/etc/apt/sources.list.d/jenkins.sources':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/jenkins/jenkins.sources",
    require => File['/etc/apt/keyrings/jenkins.asc'],
  }

  file { '/etc/apt/sources.list.d/jenkins.list':
    ensure => absent,
  }

  package { 'jenkins':
    require => File['/etc/apt/sources.list.d/jenkins.sources'],
  }

  ensure_packages ([
    'ccache',
  ])

  file { '/etc/sudoers.d/jenkins':
    mode => '0400', owner => root, group => root,
    source => "puppet:///modules/jenkins/sudoers",
    require => Package['sudo'],
  }
}
