class oftc::mx {
  # accept mail for oftc.net
  ferm::port { 'smtp':
    target => 'ACCEPT',
  }
}
