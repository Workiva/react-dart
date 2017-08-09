var webpack = require('webpack');
var BabelPlugin = require("babel-webpack-plugin");

var babelPlugin = new BabelPlugin({
   test: /\.jsx?$/,
   presets: ['es2015', 'react'],
   sourceMaps: false,
   compact: false
});

var devPlugins = [
  new webpack.DefinePlugin({
    'process.env': {
      NODE_ENV: JSON.stringify('development')
    }
  }),
  babelPlugin,
];

var prodPlugins = [
  new webpack.DefinePlugin({
    'process.env': {
      NODE_ENV: JSON.stringify('production')
    }
  }),
  babelPlugin,
  new webpack.optimize.UglifyJsPlugin()
];

module.exports = [
  // Dev
  {
    output: {filename: './lib/react_with_addons.js',},
    entry: './js_src/react.js',
    plugins: devPlugins,
  },
  {
    output: {filename: './lib/react.js',},
    entry: './js_src/react.js',
    plugins: devPlugins,
  },
  {
    output: {filename: './lib/react_dom.js',},
    entry: './js_src/react_dom.js',
    plugins: devPlugins,
  },
  {
    output: {filename: './lib/react_dom_server.js',},
    entry: './js_src/react_dom_server.js',
    plugins: devPlugins,
  },

  // Prod
  {
    output: {filename: './lib/react_prod.js',},
    entry: './js_src/react.js',
    plugins: prodPlugins,
  },
  {
    output: {filename: './lib/react_dom_prod.js',},
    entry: './js_src/react_dom.js',
    plugins: prodPlugins,
  },
  {
    output: {filename: './lib/react_dom_server_prod.js',},
    entry: './js_src/react_dom_server.js',
    plugins: prodPlugins,
  },
  {
    output: {filename: './lib/react_with_react_dom_prod.js',},
    entry: './js_src/react_with_react_dom.js',
    plugins: prodPlugins,
  },
];
