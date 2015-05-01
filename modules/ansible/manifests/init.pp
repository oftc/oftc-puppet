class ansible {
  ensure_packages(['ansible'])

  $hosts = hiera('hosts')
  $irchosts = hiera('irchosts')
  $ircservers = hiera('ircservers')
  $oftcdnshosts = hiera('oftcdnshosts')
  $vservers = hiera('vservers')

  file { '/etc/ansible/hosts':
    mode => 0644, owner => root, group => root,
    content => template('ansible/hosts'),
    require => Package['ansible'],
  }
}
