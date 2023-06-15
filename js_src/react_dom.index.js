import * as reactDomExports from './react_dom';

window.ReactDart ??= {};
Object.assign(window.ReactDart, reactDomExports);

if (process.env.NODE_ENV == 'development') {
    require('./react_dom_dev');
}
