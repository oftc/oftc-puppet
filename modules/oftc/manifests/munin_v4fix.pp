# on hosts with broken v6 listen on v4 only
class oftc::munin_v4fix {
  file_line { 'listen on v4 only':
    path => '/etc/munin/munin-node.conf',
    line => "host $::ipaddress",
    match => '^host ',
    require => Package['munin-node'],
    notify => Service['munin-node'],
  }
}
