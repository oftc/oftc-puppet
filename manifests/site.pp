node default {
  include oftc::common

  if $::hostname in hiera('oftcdnshosts') {
    include oftc::oftcdns
  }

  if $::hostname in hiera('v4onlyhosts') {
    include oftc::munin_v4fix
  }

}
