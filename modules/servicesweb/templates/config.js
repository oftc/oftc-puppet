module.exports = {
    listen: {
        host: '127.0.0.1',
        port: 8000,
    },
    connectionString: {
        user:     'servicesweb',  // env var: PGUSER
        database: 'ircservices',  // env var: PGDATABASE
        password: '<%= @servicesweb_pass %>', // env var: PGPASSWORD
        port:     5432,           // env var: PGPORT
        max:      10,             // max number of clients in the pool
        idleTimeoutMillis: 30000, // how long a client is allowed to remain idle before being closed
    },
    tokenSecret: '<%= @servicesweb_tokensecret %>',
}
