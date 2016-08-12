class oftc::webirc {

  class { '::webirc':
    ircport => 6697,
    webircpass => hiera('webircpass'),
    certname => 'webirc.oftc.net',
    redirect => 'webchat.oftc.net',
  }

  ferm::port { 'webirc':
    port => '8443',
    target => 'ACCEPT',
  }

}
