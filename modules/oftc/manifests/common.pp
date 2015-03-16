class oftc::common {
  package { 'mtr-tiny': }
  include oftc::munin
  include oftc::ssh
}
