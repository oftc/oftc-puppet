# run puppet every 30min from cron instead of daemonizing
class oftc::puppet {
  $hash = fqdn_rand(30)
  file { '/etc/cron.d/puppet':
    mode => 0644, owner => root, group => root,
    content => template('oftc/cron.d.puppet'),
  }

  service { 'puppet':
    ensure => stopped,
    enable => false,
    require => File['/etc/cron.d/puppet'],
  }
}
