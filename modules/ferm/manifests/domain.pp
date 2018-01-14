class ferm::domain {

  ferm::port { 'domain/udp':
    port => 'domain',
    proto => 'udp',
    target => 'ACCEPT',
  }
  ferm::port { 'domain':
    target => 'ACCEPT',
  }

}
