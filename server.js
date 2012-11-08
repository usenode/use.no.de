#!/bin/env node
/*
This should really just invoke Proton (use.no.de/proton) however it doesn't
work with node v6.
@see https://github.com/usenode/proton.js/issues/5
*/
var jsgi     = require('jsgi'),
    http     = require('http'),
    WebApp   = require('./lib/webapp').WebApp,
    all      = require('promised-io/promise').all;

var options = {
    'bindTo': '0.0.0.0',
    'port'  : 8080
};

var webapp = new WebApp();

all(webapp._protonBeforeStart).then(function () {

    var server = http.createServer(
        new jsgi.Listener(function (request) {
            return webapp.handle(request);
        })
    );

    server.listen(options.port || 80, options.bindTo);

    console.log(
        'Webapp listening on ' +
        (options.bindTo) +
        ':' +
        (options.port)
    );
});
