class oftc::ircservices {
  ensure_packages ([
    'build-essential',
    'zlib1g-dev',
    'libevent-dev',
    'libpq-dev', 'postgresql-server-dev-all',
    'libssl-dev',
  ])
}
