class ansible {
  ensure_packages(['ansible'])

  $oftchosts = hiera('oftchosts')
  $irchosts = hiera('irchosts')
  $ircservers = hiera('ircservers')
  $vservers = hiera('vservers')

  file { '/etc/ansible/hosts':
    mode => 0644, owner => root, group => root,
    content => template('ansible/hosts'),
    require => Package['ansible'],
  }
}
