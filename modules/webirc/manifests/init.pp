class webirc (
  $ircport,
  $webircpass,
  $certname,
  $redirect,
) {

  ensure_packages([
    'npm',
  ])

  $home = "/home/oftc/webirc"
  $ircws = "${home}/node-ircws"

  user { 'webirc':
    home => $home,
    managehome => true,
    comment => 'node-ircws user',
    shell => '/bin/bash',
    groups => 'ssl-cert',
    require => Package['ca-certificates'],
  }

  exec { 'enable-linger-webirc':
    command => '/bin/loginctl enable-linger webirc',
    creates => '/var/lib/systemd/linger/webirc',
    require => User['webirc'],
  }

  file {[
    '/home/oftc/webirc/',
    '/home/oftc/webirc/.config/',
    '/home/oftc/webirc/.config/systemd/',
    '/home/oftc/webirc/.config/systemd/user/',
    #'/home/oftc/webirc/.config/systemd/user/default.target.wants/',
  ]:
    ensure => directory,
    owner => webirc, group => webirc, mode => 755,
  }

  file { '/home/oftc/webirc/.config/systemd/user/webirc.service':
    owner => webirc, group => webirc, mode => 644,
    content => template("webirc/webirc.service"),
    require => User['webirc'],
  }

  exec { 'node-ircws.git':
    command => "/usr/bin/git clone https://github.com/oftc/node-ircws.git ${ircws}",
    user => 'webirc',
    creates => $ircws,
    require => [
      Package['git'],
      User['webirc'],
    ],
  }

  file { "${ircws}/config.js":
    owner => webirc, group => webirc, mode => '0600',
    content => template("webirc/config.js"),
    require => Exec['node-ircws.git'],
  }

  exec { 'ircws_node_modules':
    command => "/usr/bin/npm install",
    user => 'webirc',
    cwd => $ircws,
    creates => "${ircws}/node_modules",
    require => Exec['node-ircws.git'],
  }

}
