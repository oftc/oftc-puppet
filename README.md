oftc-puppet
===========

These are the puppet classes driving the hosts running oftc.net. The actual
host->class mapping is done in LDAP and is not part of this repository.
The hieradata is also in a separate repository.

Bootstrapping
-------------

apt-get install puppet ruby-ldap

Get puppet schema: https://github.com/puppetlabs/puppet/blob/master/ext/ldap/puppet.schema

User environment
----------------

For developing and testing changes to oftc-puppet, it is best to create your
own "environment" (in puppet speak). In your $HOME on the puppet master, do:

```
HOME$ git clone git@github.com:oftc/oftc-puppet.git
HOME$ cd oftc-puppet
oftc-puppet$ git clone /srv/git/oftc-hieradata-private.git/ hieradata
oftc-puppet$ sudo ln -s $HOME/oftc-puppet /etc/puppet/environments/$USER
oftc-puppet$ sudo ln -s $HOME/oftc-puppet/hieradata/oftc.yaml /etc/puppet/hieradata/$USER.yaml
oftc-puppet$ ... hack away ...
```

On the host in question, do `sudo puppet agent -t --environment $USER`. The
only thing that can't be tested without pushing first is changes to
hieradata/$HOST.yaml. Also, the list of puppet classes from LDAP is fixed and
not configurable per environment.

```
oftc-puppet$ git commit && git push
oftc-puppet/hieradata$ git commit && git push
```
