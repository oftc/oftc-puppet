oftc-puppet
===========

These are the puppet classes driving the hosts running oftc.net. The actual
host->class mapping is done in LDAP and is not part of this repository.

Bootstrapping
-------------

apt-get install puppet ruby-ldap

Get puppet schema: https://github.com/puppetlabs/puppet/blob/master/ext/ldap/puppet.schema
