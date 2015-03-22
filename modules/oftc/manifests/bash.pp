class oftc::bash {
  file { '/etc/bash.bashrc':
    mode => 0644, owner => root, group => root,
    source => "puppet:///modules/oftc/bash.bashrc",
  }
}
