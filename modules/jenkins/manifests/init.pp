class jenkins {
  file { '/etc/apt/trusted.gpg.d/jenkins-ci.org.asc':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/jenkins/jenkins-ci.org.asc",
  }

  apt::source { 'jenkins':
    location          => 'https://pkg.jenkins.io/debian binary/',
    release           => '',
    repos             => '',
    key               => '63667EE74BBA1F0A08A698725BA31D57EF5975CA',
    require           => File['/etc/apt/trusted.gpg.d/jenkins-ci.org.asc'],
  }

  package { 'jenkins':
    require => Apt::Source['jenkins'],
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
