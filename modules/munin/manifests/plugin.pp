define munin::plugin (
  $link = $title,
  $plugin = $title,
  $directory = '/usr/share/munin/plugins',
  $content = undef,
  $conf = undef,
) {

  if ("$content" != "") {
    file { "${directory}/${plugin}":
      mode => "0755", owner => root, group => root,
      content => $content,
      require => Package['munin-node'],
    }
  }

  file { "/etc/munin/plugins/$link":
    ensure => link,
    target => "$directory/$plugin",
    require => Package['munin-node'],
    notify => Service['munin-node'],
  }

  if ("$conf" != "") {
    file { "/etc/munin/plugin-conf.d/${plugin}":
      mode => "0600", owner => root, group => root,
      content => "[${plugin}]\n${conf}\n",
      require => Package['munin-node'],
      notify => Service['munin-node'],
    }
  }

}
