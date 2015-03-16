define munin::plugin ($plugin = $title) {
  file { "/etc/munin/plugins/$plugin":
    ensure => link,
    target => "/usr/share/munin/plugins/$plugin",
    notify => Service['munin-node'],
  }
}
