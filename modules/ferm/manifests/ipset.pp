define ferm::ipset (
  $ipset = $title,
  $type = "hash:net",
  $family,
  $list = undef,
  $content = "",
) {

  if $list {
    $c = join(concat($list, ""), "\n")
  } else {
    $c = $content
  }

  file { "/etc/ipset/${title}":
    owner => root, group => root, mode => '0644',
    content => $c,
    notify => Exec["ipset-load ${title}"],
  }

  exec { "ipset-load ${title}":
    command => "/usr/local/sbin/ipset-load -f ${ipset} '${type} family ${family}' /etc/ipset/${title}",
    refreshonly => true,
    require => File['/usr/local/sbin/ipset-load'],
  }

}
