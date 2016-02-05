class oftc::www {
  ensure_packages([
    'apache2'
  ])
  include acme_tiny
}
