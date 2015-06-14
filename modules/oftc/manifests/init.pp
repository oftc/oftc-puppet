class oftc {
  include backuppc
  include oftc::base
  include oftc::cert
  include oftc::git
  include munin::node
  include oftc::nrpe
  include ntp
  include oftc::puppet
  include oftc::recvconf
  include oftc::ssh
  include syslog-ng
  include userdir-ldap
}
