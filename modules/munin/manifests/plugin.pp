define munin::plugin (
  $link = $title,
  $plugin = $title,
  $directory = '/usr/share/munin/plugins',
) {
  file { "/etc/munin/plugins/$link":
    ensure => link,
    target => "$directory/$plugin",
    require => Package['munin-node'],
    notify => Service['munin-node'],
  }
}
