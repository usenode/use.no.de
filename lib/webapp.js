
var micro    = require('micro/micro'),
    spectrum = require('spectrum');

var WebApp = exports.WebApp = micro.webapp(),
    get = WebApp.get;

WebApp.prototype.init = function () {
    this.view = new spectrum.Renderer(__dirname + '/../views');
};

get('/', function (request, response) {
    return this.view.render('/index.spv', {}).then(function (output) {
        response.ok('text/html');
        return output;
    });
});

get('/tutorials/getting-started-with-micro-and-spectrum', function (request, response) {
    return this.view.render('/tutorials/getting-started-with-micro-and-spectrum.spv', {}).then(function (output) {
        response.ok('text/html');
        return output;
    });
});

WebApp.handleStatic(__dirname.replace(/\/lib$/, '/static'));


