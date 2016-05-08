class oftc::domain {
  # TODO: use more specific classes

  ferm::port { 'domain/udp':
    port => 'domain',
    proto => 'udp',
    target => 'ACCEPT',
  }
  ferm::port { 'domain':
    target => 'ACCEPT',
  }

}
