class userdir-ldap::master {
  ensure_packages ([
    'python-dsa-mq',
    'python-kombu',
  ])

  # run every 15min from cron
  $hash = fqdn_rand(15)
  file { '/etc/cron.d/ud-generate':
    mode => 0644, owner => root, group => root,
    content => template('userdir-ldap/cron.d.ud-generate'),
  }

  ferm::port { 'ldap':
    port => 'ldap ldaps',
  }

  ferm::port { 'www':
    port => 'http https',
    target => 'ACCEPT',
  }

}
