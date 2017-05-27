# make "systemctl --user" work (needs -i when used with "sudo -u oftc [-i] $cmd")
[ -z "$XDG_RUNTIME_DIR" ] && [ "$EUID" ] && [ "$EUID" -gt 0 ] && [ -d /run/user/$EUID ] && export XDG_RUNTIME_DIR=/run/user/$EUID
