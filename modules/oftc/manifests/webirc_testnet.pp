class oftc::webirc_testnet {

  class { '::webirc':
    ircport => 16697,
    webircpass => hiera('webircpass'),
    certname => 'webirc-testnet.oftc.net',
    redirect => 'webirc-testnet.oftc.net',
  }

  ferm::port { 'webirc':
    port => '8443',
    target => 'jump STAFF',
  }

}
