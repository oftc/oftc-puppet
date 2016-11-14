class oftc::www {
  ensure_packages([
    'apache2',
    'jekyll',
    'ruby-gsl',
  ])

  class { 'servicesweb':
    host => 'services-testnet.oftc.net',
    servicesweb_pass => hiera('servicesweb_pass'),
    servicesweb_tokensecret => hiera('servicesweb_tokensecret'),
  }

  ferm::port { 'www':
    port => 'http https',
    target => 'ACCEPT',
  }

}
