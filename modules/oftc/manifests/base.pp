class oftc::base {
  ensure_packages [
    'mtr-tiny',
    'less',
    'lsb-release',
    'psmisc',
    'tree',
    'vim',
    'zsh',
  ]

  if !($::hostname in hiera('vservers')) {
    ensure_packages['ulogd']
  }

}
