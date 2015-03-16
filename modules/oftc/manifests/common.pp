class oftc::common {
  package { 'mtr-tiny': }
  include oftc::munin
  include oftc::puppet
  include oftc::ssh
}
