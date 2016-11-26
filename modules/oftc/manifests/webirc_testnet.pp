class oftc::webirc_testnet {

  # webirc

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

  # servicesweb

  class { 'servicesweb':
    host => 'services-testnet.oftc.net',
    servicesweb_pass => hiera('servicesweb_pass_test'),
    servicesweb_tokensecret => hiera('servicesweb_tokensecret_test'),
    servicesweb_recaptcha_sitekey => hiera('servicesweb_recaptcha_sitekey'),
    servicesweb_recaptcha_secretkey => hiera('servicesweb_recaptcha_secretkey'),
  }

  # also used for jenkins
  ferm::port { 'www':
    port => 'http https',
    target => 'ACCEPT',
  }

}
