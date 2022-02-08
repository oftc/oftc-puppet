class ferm::irker {
  ferm::port { 'irker udp':
    port => '6659',
    proto => 'udp',
    target => 'saddr ($admin_ip4) ACCEPT',
  }
  ferm::port { 'irker tcp':
    port => '6659',
    proto => 'tcp',
    target => 'saddr ($admin_ip4) ACCEPT',
  }
}
