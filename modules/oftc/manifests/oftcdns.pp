class oftc::oftcdns {
  ensure_packages ([
    'kwalify',
  ])

  file_line { 'oftcdns mail alias':
    path => '/etc/aliases',
    line => "oftcdns: root\n",
    match => "^oftcdns:",
    notify => Exec['newaliases'],
  }

  # oftcdns
  include oftc::domain
  ferm::port { 'oftcdns/snmp':
    port => 40161,
    proto => 'udp',
  }

  # statbot
  ferm::port { 'statbot':
    port => '8789',
  }
  # snmp port is 40162
}
