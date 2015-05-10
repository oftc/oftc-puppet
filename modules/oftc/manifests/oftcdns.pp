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
}
