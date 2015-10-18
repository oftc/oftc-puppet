class oftc::configmaster {
  include ansible
  include munin
  include smokeping
  include userdir-ldap::master
}
