node default {
  include oftc::common

  if $::hostname in hiera('irchosts') {
    include oftc::irc
  }

  if $::hostname in hiera('oftcdnshosts') {
    include oftc::oftcdns
  }

  if !($::hostname in hiera('specialmta')) {
    include postfix
  }

  if $::hostname in hiera('vservers') {
    include oftc::munin_v4fix
  }

}
