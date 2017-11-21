class userdir_ldap {
  apt::key { 'db.debian.org':
    id => 'D984518A0DCB4EEC519573DF661EBB0E456D79AB',
    content => template('userdir_ldap/db.debian.org.asc'),
    server => 'hkps.pool.sks-keyservers.net', # suppress a warning in /usr/share/puppet/modules/apt/manifests/key.pp
  }

  apt::source { 'db.debian.org':
    location => 'http://db.debian.org/debian-admin',
    release => 'debian-all',
    repos => 'main',
    require => Apt::Key['db.debian.org'],
  }

  package { 'userdir-ldap':
    require => Apt::Source['db.debian.org'],
  }

  $configserver = hiera('configserver')
  file { '/etc/userdir-ldap/userdir-ldap.conf':
    mode => '0644', owner => root, group => root,
    content => template('userdir_ldap/userdir-ldap.conf'),
    require => Package['userdir-ldap'],
  }

  # run every 15min from cron instead of daemonizing
  $hash = fqdn_rand(14) + 1 # on master: 1 min after ud-generate
  file { '/etc/cron.d/ud-replicate':
    mode => '0644', owner => root, group => root,
    content => template('userdir_ldap/cron.d.ud-replicate'),
  }

  file_line { 'nss passwd':
     path => '/etc/nsswitch.conf',
     line => "passwd:         compat db",
     match => '^passwd:',
  }

  file_line { 'nss group':
     path => '/etc/nsswitch.conf',
     line => "group:          db compat",
     match => '^group:',
  }

  file_line { 'nss shadow':
     path => '/etc/nsswitch.conf',
     line => "shadow:         compat db",
     match => '^shadow:',
  }

  # https://help.ubuntu.com/community/LDAPClientAuthentication#Automatically_create_home_folders
  file { '/usr/share/pam-configs/mkhomedir':
    content => template('userdir_ldap/mkhomedir'),
    notify => Exec['pam-auth-update'],
  }

  exec { 'pam-auth-update':
    command => '/usr/sbin/pam-auth-update',
    refreshonly => true,
  }

  file { '/etc/sudoers.d/oftc-admin':
    mode => '0440', owner => root, group => root,
    content => "%oftc-admin ALL=(ALL) NOPASSWD: ALL\n",
    require => Package['sudo'],
  }
}
