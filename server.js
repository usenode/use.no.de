
var proton = require('proton'),
    sys    = require('sys');

proton.run(
    require(__dirname + '/lib/webapp.js').WebApp,
    { port: 80 },
    function (e) {
        sys.error(e);
        process.exit(1);
    }
);

