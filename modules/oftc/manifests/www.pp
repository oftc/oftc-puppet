class oftc::www {
  ensure_packages([
    'apache2',
    'jekyll',
    'ruby-gsl',
  ])

  ferm::port { 'www':
    port => 'http https',
    target => 'ACCEPT',
  }

}
