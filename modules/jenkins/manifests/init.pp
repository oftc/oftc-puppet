class jenkins {
  file { '/etc/apt/trusted.gpg.d/jenkins-ci.org.asc':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/jenkins/jenkins-ci.org.asc",
  }

  apt::source { 'jenkins':
    location          => 'http://pkg.jenkins-ci.org/debian-stable binary/',
    release           => '',
    repos             => '',
    key               => '150FDE3F7787E7D11EF4E12A9B7D32F2D50582E6',
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
