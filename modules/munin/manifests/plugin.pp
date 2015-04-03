define munin::plugin ($plugin = $title) {
  file { "/etc/munin/plugins/$plugin":
    ensure => link,
    target => "/usr/share/munin/plugins/$plugin",
    require => Package['munin-node'],
    notify => Service['munin-node'],
  }
}
