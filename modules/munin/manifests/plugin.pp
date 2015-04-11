define munin::plugin (
  $plugin = $title,
  $directory = '/usr/share/munin/plugins',
) {
  file { "/etc/munin/plugins/$plugin":
    ensure => link,
    target => "$directory/$plugin",
    require => Package['munin-node'],
    notify => Service['munin-node'],
  }
}
