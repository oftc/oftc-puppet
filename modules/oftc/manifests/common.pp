class oftc::common {
  package { 'mtr-tiny': }
  include oftc::munin
  include oftc::nrpe
  include oftc::puppet
  include oftc::ssh
}
