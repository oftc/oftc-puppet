define ferm::port (
  $port = $title,
  $proto = 'tcp',
  $sequence = '60',
  $target = 'jump OFTC', # or 'ACCEPT'
) {

  if ($port =~ / /) {
    $portstatement = "mod multiport destination-ports ($port)"
  } else {
    $portstatement = "dport ($port)"
  }

  concat::fragment { "ferm_$title":
    target  => '/etc/ferm/ferm.conf',
    order   => $sequence,
    content => "# $title\ndomain (ip ip6) chain INPUT proto $proto $portstatement $target;\n",
  }

}
