require('./scss/app.scss');

var Elm = require('./elm/Main');
Elm.embed(Elm.Main, document.getElementById('app'))
