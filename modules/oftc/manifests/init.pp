class oftc {
  include backuppc
  include oftc::base
  include oftc::cert
  if $::hostname != "photon.oftc.net" { # still a vserver
  include ferm
  }
  include oftc::git
  include munin::node
  include oftc::nrpe
  include ntp
  include oftc::puppet
  include oftc::recvconf
  include oftc::ssh
  include syslog_ng
  include userdir_ldap
}
