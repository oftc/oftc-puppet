class oftc::base {
  ensure_packages [
    'at',
    'less',
    'lsb-release',
    'mtr-tiny',
    'ntp',
    'psmisc',
    'subversion',
    'tree',
    'vim',
    'zsh',
  ]

  if !($::hostname in hiera('vservers')) {
    ensure_packages['ulogd']
  }

}
