var fs = require('fs');
var path = require('path');

var key = fs.readFileSync('/etc/ssl/private/<%= @certname %>.key');
var cert = fs.readFileSync('/etc/ssl/certs/<%= @certname %>-chained.pem');
var ca = fs.readFileSync('/etc/ssl/certs/<%= @certname %>-chained.pem');

var irccertPath = path.join('/home/oftc/oftc', 'hybrid', 'etc', 'here-certificate.pem');
var irccert = fs.readFileSync(irccertPath);

module.exports = {
  listeners: [
/*
    {
      host: '0.0.0.0',
      type: 'plain',
      port: 26667,
      enabled: true,
    },
*/
    {
      host: '0.0.0.0',
      type: 'tls',
      port: 16698,
      key: key,
      cert: cert,
      enabled: true,
    },
    {
      host: '0.0.0.0',
      type: 'socketio',
      port: 8443,
      key: key,
      cert: cert,
      ca: [ ca ],
      enabled: true,
      redirectUrl: 'https://<%= @redirect %>',
    },
  ],
  destination: {
    host: '127.0.0.1',
    //port: '16667',
    //type: 'plain',
    port: '<%= @ircport %>',
    type: 'tls',
    // you can specify TLS valid config options, see:
    // https://nodejs.org/api/tls.html#tls_tls_connect_port_host_options_callback
    rejectUnauthorized: false,
    webirc_password: '<%= @webircpass %>',
  },
  cloaks: [
      path.join(__dirname, 'ca.crt'),
  ],
  reconnectTime: 15 * 1000,
  blockTor: true,
  dnsbl: {
    maxScore: 1,
    servers: {
      'dronebl': {
        zone: 'dnsbl.dronebl.org',
        defaultScore: 1,
      },
      'tor-oftc': {
        zone: 'tor-irc.dnsbl.oftc.net',
        defaultScore: -1,
        defaultCloak: 'tor-irc.dnsbl.oftc.net',
        records: {
                "127.0.0.1": {
                reason: "Tor exit node, allows 6667 outbound",
                score: -1,
                isTor: true,
                },
        },
        },
        'tor-efnet': {
        zone: "tor.efnetrbl.org",
        defaultCloak: "tor-irc.dnsbl.oftc.net",
        defaultScore: -1,
        records: {
                "127.0.0.1": {
                "reason": "Tor exit node, allows 6667 outbound",
                isTor: true,
                }
        }
        },
      'efnet': {
        zone: "rbl.efnetrbl.org",
        defaultScore: 1,
        records: {
                "127.0.0.1": {
                "reason": "Open Proxy"
                },
                "127.0.0.2": {
                "reason": "Spamtrap hosts with scores of 666"
                },
                "127.0.0.3": {
                "reason": "Spamtrap hosts with scores of 50 or more"
                },
                "127.0.0.4": {
                "reason": "tor exit node",
                "score": -1,
                isTor: true,
                },
                "127.0.0.5": {
                "reason": "Drones/Flooding"
                }
        }
        },
        'dronebl': {
        zone: "dnsbl.dronebl.org",
        defaultScore: 1,
        records: {
                "127.0.0.3": {
                "reason": "IRC Drone"
                },
                "127.0.0.5": {
                "reason": "Bottler"
                },
                "127.0.0.6": {
                "reason": "Unknown spambot or drone"
                },
                "127.0.0.7": {
                "reason": "DDOS Drone"
                },
                "127.0.0.8": {
                "reason": "SOCKS Proxy"
                },
                "127.0.0.9": {
                "reason": "HTTP Proxy"
                },
                "127.0.0.10": {
                "reason": "ProxyChain"
                },
                "127.0.0.13": {
                "reason": "Brute force attacker"
                },
                "127.0.0.14": {
                "reason": "Open Wingate Proxy"
                },
                "127.0.0.15": {
                "reason": "Compromised router / gateway"
                },
                "127.0.0.17": {
                "reason": "Automated entry (Experimental)",
                "score": 0
                }
        }
        },
        'sorbs-proxy': {
        zone: "proxies.dnsbl.sorbs.net",
        defaultScore: 1,
        },
    },
  },
};
