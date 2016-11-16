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
    servicesweb_recaptcha_sitekey => hiera('servicesweb_recaptcha_sitekey'),
    servicesweb_recaptcha_secretkey => hiera('servicesweb_recaptcha_secretkey'),
  }

  ferm::port { 'www':
    port => 'http https',
    target => 'ACCEPT',
  }

}
