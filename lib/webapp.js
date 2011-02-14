
var micro    = require('micro'),
    spectrum = require('spectrum');

var WebApp = exports.WebApp = micro.webapp(),
    get = WebApp.get;

WebApp.prototype.init = function () {
    this.view = new spectrum.Renderer(__dirname + '/../views');
};

WebApp.handlePublicTemplates('.pub.spv', function (request, response, template) {
    var content = template.render({});
    response.ok('text/html');
    return content;
});

WebApp.handleStatic(__dirname.replace(/\/lib$/, '/static'));
