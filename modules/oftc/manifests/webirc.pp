class oftc::webirc {

  ferm::port { 'webirc':
    port => '8443',
    target => 'jump STAFF',
  }

}
