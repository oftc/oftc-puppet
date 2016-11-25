class oftc::www {
  ensure_packages([
    'apache2',
    'jekyll',
    'ruby-gsl',
  ])

  class { 'servicesweb':
    host => 'services.oftc.net',
    pghost => hiera('ircservices_host'),
    pgport => 5433,
    servicesweb_pass => hiera('servicesweb_pass_prod'),
    servicesweb_tokensecret => hiera('servicesweb_tokensecret_prod'),
    servicesweb_recaptcha_sitekey => hiera('servicesweb_recaptcha_sitekey'),
    servicesweb_recaptcha_secretkey => hiera('servicesweb_recaptcha_secretkey'),
  }

  ferm::port { 'www':
    port => 'http https',
    target => 'ACCEPT',
  }

}
