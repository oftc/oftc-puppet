define munin::plugin (
  $link = $title,
  $plugin = $title,
  $directory = '/usr/share/munin/plugins',
  $content = undef,
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

}
