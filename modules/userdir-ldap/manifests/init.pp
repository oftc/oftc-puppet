class userdir-ldap {
  apt::key { 'db.debian.org':
    key => 'D984518A0DCB4EEC519573DF661EBB0E456D79AB',
    key_content => template('userdir-ldap/db.debian.org.asc'),
  }

  apt::source { 'db.debian.org':
    location => 'http://db.debian.org/debian-admin',
    release => 'debian-all',
    repos => 'main',
    include_src => false,
    require => Apt::Key['db.debian.org'],
  }

  package { 'userdir-ldap':
    require => Apt::Source['db.debian.org'],
  }

  # run every 15min from cron instead of daemonizing
  $hash = fqdn_rand(14) + 1 # on master: 1 min after ud-generate
  file { '/etc/cron.d/ud-replicate':
    mode => 0644, owner => root, group => root,
    content => template('userdir-ldap/cron.d.ud-replicate'),
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
    content => template('userdir-ldap/mkhomedir'),
    notify => Exec['pam-auth-update'],
  }

  exec { 'pam-auth-update':
    command => '/usr/sbin/pam-auth-update',
    refreshonly => true,
  }

  file { '/etc/sudoers.d/oftc-admin':
    mode => 0440, owner => root, group => root,
    content => "%oftc-admin ALL=(ALL) ALL\n",
    require => Package['sudo'],
  }
}
