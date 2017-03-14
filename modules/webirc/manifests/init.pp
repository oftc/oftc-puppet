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

  # clean up from when we used a user systemd instance
  file {[
    '/home/oftc/webirc/.config/',
    '/var/lib/systemd/linger/webirc',
  ]:
    ensure => absent,
    force => true,
    notify => Exec['systemctl daemon-reload'],
  }

  file { '/lib/systemd/system/webirc.service':
    owner => root, group => root, mode => '644',
    content => template("webirc/webirc.service"),
    notify => Exec['systemctl daemon-reload'],
  }

  service { 'webirc':
    enable => true,
    require => File['/lib/systemd/system/webirc.service'],
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

  # sudo
  file { '/etc/sudoers.d/webirc':
    mode => '0400', owner => root, group => root,
    content => template("webirc/sudoers.webirc"),
    require => Package['sudo'],
  }

  # munin monitoring
  munin::plugin { 'webirc':
    content => template('webirc/webirc.munin'),
  }

}
