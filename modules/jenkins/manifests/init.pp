class jenkins {
  file { '/etc/apt/jenkins-ci.org.key':
    mode => '0644', owner => root, group => root,
    source => "puppet:///modules/jenkins/jenkins-ci.org.key",
  }

  exec { 'jenkins-ci.org.gpg':
    command => '/usr/bin/apt-key --keyring /etc/apt/trusted.gpg.d/jenkins-ci.org.gpg add /etc/apt/jenkins-ci.org.key',
    require => File['/etc/apt/jenkins-ci.org.key'],
    creates => '/etc/apt/trusted.gpg.d/jenkins-ci.org.gpg'
  }
}
