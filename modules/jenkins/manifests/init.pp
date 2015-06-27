class jenkins {
  apt::source { 'jenkins':
    location          => 'http://pkg.jenkins-ci.org/debian-stable binary/',
    release           => '',
    repos             => '',
    key               => '150FDE3F7787E7D11EF4E12A9B7D32F2D50582E6',
    key_source        => 'http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key',
    include_src       => false,
  }

  package { 'jenkins':
    require => Apt::Source['jenkins'],
  }

  file { '/etc/sudoers.d/jenkins':
    mode => '0400', owner => root, group => root,
    source => "puppet:///modules/jenkins/sudoers",
    require => Package['sudo'],
  }
}
