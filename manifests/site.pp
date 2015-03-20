include oftc::common

node default {
}

node 'radian.oftc.net' {
  include oftc::oftcdns
  include oftc::munin_v4fix
}
