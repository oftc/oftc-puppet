class oftc::common {
  include oftc::base
  include oftc::bash
  include oftc::cert
  include oftc::git
  include munin::node
  include oftc::nrpe
  include ntp
  include oftc::puppet
  include oftc::recvconf
  include oftc::ssh
  include oftc::sudo
  include syslog-ng
  include userdir-ldap
}
