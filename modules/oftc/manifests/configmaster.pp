class oftc::configmaster {
  include ansible
  include munin
  include userdir-ldap::master
}
