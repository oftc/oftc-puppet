class oftc::puppet {
  # run puppet every 60min from cron instead of daemonizing
  $hash = fqdn_rand(60)
  file { '/etc/cron.d/puppet':
    mode => '0644', owner => root, group => root,
    content => template('oftc/cron.d.puppet'),
  }

  service { 'puppet':
    ensure => stopped,
    enable => false,
    require => File['/etc/cron.d/puppet'],
  }

  if $::puppetversion =~ /^2/ {
    augeas { 'puppet.conf':
      context => '/files/etc/puppet/puppet.conf',
      changes => [
	'set main/pluginsync true', # default in puppet 3.x
      ],
    }
  }
}
