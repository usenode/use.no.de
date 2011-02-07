
var micro    = require('micro/micro'),
    spectrum = require('spectrum');

var WebApp = exports.WebApp = micro.webapp(),
    get = WebApp.get;

WebApp.prototype.init = function () {
    this.view = new spectrum.Renderer(__dirname + '/../views');
};


get(/^((?:\/[\w-]+)+)\/$/, function (request, response, path) {
    return response.redirect(path, true);
});

get(/^(?:(\/)|((?:\/[\w-]+)+))$/, function (request, response, index, path) {
    if (path && path === '/index') {
        return response.redirect('/', true);
    }
    var templatePath = index ? '/index' : path,
        view = this.view;
    return this.view.loadTemplate(templatePath + '.pub.spv').then(function (template) {
        var content = template.render({});
        response.ok('text/html');
        return content;
    });
});

WebApp.handleStatic(__dirname.replace(/\/lib$/, '/static'));


