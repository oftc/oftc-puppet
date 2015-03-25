class oftc::udldap {
  apt::key { 'db.debian.org':
    key => 'D984518A0DCB4EEC519573DF661EBB0E456D79AB',
    key_content => template('oftc/db.debian.org.asc'),
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
}
