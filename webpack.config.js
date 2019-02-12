var webpack = require('webpack');

var moduleDevConfig = {
  rules: [
    {
      test: /\.jsx?$/,
      use: {
        loader: 'babel-loader',
        options: {
          presets: ['@babel/preset-env', '@babel/preset-react']
        }
      },
    }
  ]
}

var moduleProdConfig = moduleDevConfig;
moduleProdConfig.rules[0].use.options.presets.push(['minify', {
  builtIns: false,
  evaluate: false,
  mangle: false,
}]);

module.exports = [
  // Dev
  {
    output: {filename: './lib/react_with_addons.js',},
    entry: './js_src/react.js',
    mode: 'development',
    module: moduleDevConfig,
  },
  {
    output: {filename: './lib/react.js',},
    entry: './js_src/react.js',
    mode: 'development',
    module: moduleDevConfig,
  },
  {
    output: {filename: './lib/react_dom.js',},
    entry: './js_src/react_dom.js',
    mode: 'development',
    module: moduleDevConfig,
  },
  {
    output: {filename: './lib/react_dom_server.js',},
    entry: './js_src/react_dom_server.js',
    mode: 'development',
    module: moduleDevConfig,
  },

  // Prod
  {
    output: {filename: './lib/react_prod.js',},
    entry: './js_src/react.js',
    mode: 'production',
    module: moduleProdConfig,
  },
  {
    output: {filename: './lib/react_dom_prod.js',},
    entry: './js_src/react_dom.js',
    mode: 'production',
    module: moduleProdConfig,
  },
  {
    output: {filename: './lib/react_dom_server_prod.js',},
    entry: './js_src/react_dom_server.js',
    mode: 'production',
    module: moduleProdConfig,
  },
  {
    output: {filename: './lib/react_with_react_dom_prod.js',},
    entry: './js_src/react_with_react_dom.js',
    mode: 'production',
    module: moduleProdConfig,
  },
];
