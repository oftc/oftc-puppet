class ircservices {
  ensure_packages ([
    'build-essential',
    'pkg-config',
    'zlib1g-dev',
    'libevent-dev',
    'autoconf', 'automake', 'libtool', 'libltdl-dev',
    'libpq-dev', 'postgresql-server-dev-all',
    'libssl-dev',
    'ruby', 'ruby-dev',
    'flex', 'bison',
  ])

  # init/oftc_user are custom facts from facts.d/oftc
  if ($init == 'systemd') {
    ensure_packages (['libpam-systemd'])

    # needs first ud-replicate run for the user to exist
    exec { 'enable-linger-ircservices':
      command => '/bin/loginctl enable-linger ircservices',
      creates => '/var/lib/systemd/linger/ircservices',
    }
  }

  file {[
    '/home/oftc/ircservices/',
    '/home/oftc/ircservices/.config/',
    '/home/oftc/ircservices/.config/systemd/',
    '/home/oftc/ircservices/.config/systemd/user/',
    #'/home/oftc/ircservices/.config/systemd/user/default.target.wants/',
  ]:
    ensure => directory,
    owner => ircservices, group => ircservices, mode => 755,
  }

  file { '/home/oftc/ircservices/.config/systemd/user/ircservices.service':
    owner => ircservices, group => ircservices, mode => 644,
    source => "puppet:///modules/ircservices/ircservices.service",
  }

  #file { '/home/oftc/ircservices/.config/systemd/user/default.target.wants/ircservices.service':
  #  owner => ircservices, group => ircservices, mode => 644,
  #  ensure => link,
  #  target => '../ircservices.service',
  #}

  # /usr/lib/ruby/2.1.0/openssl/buffering.rb must not contain "coding: binary". wtf.
  # RUBY ERROR: ArgumentError: unknown encoding name: binary

  include oftc::postgresql
}
