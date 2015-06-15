class backuppc::server {
  service { 'backuppc': }

  $hosts = hiera('hosts')
  file { '/etc/backuppc/hosts':
    mode => '0644', owner => 'backuppc', group => 'www-data',
    content => template('backuppc/hosts'),
    notify => Service['backuppc'],
  }
}
