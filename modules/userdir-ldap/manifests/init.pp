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

  ensure_packages [
    'libnss-db',
  ]

  # run every 15min from cron instead of daemonizing
  $hash = fqdn_rand(14) + 1 # on master: 1 min after ud-generate
  file { '/etc/cron.d/ud-replicate':
    mode => 0644, owner => root, group => root,
    content => template('userdir-ldap/cron.d.ud-replicate'),
  }
}
