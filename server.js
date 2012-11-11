#!/bin/env node

var proton   = require('proton'),
    WebApp   = require('./lib/webapp').WebApp;

var options = {
    'bindTo': '0.0.0.0',
    'port'  : 8080
};

proton.run(WebApp, options);