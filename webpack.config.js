var webpack = require('webpack');
const path = require('path');

var babelPlugin = new webpack.DefinePlugin({
  test: /\.jsx?$/,
  use: {
    loader: 'babel-loader',
    options: {
        presets: ['@babel/preset-env', '@babel/preset-react']
    }
  },
});

var outputPath = path.resolve(__dirname,'lib/');
var inputPath = path.resolve(__dirname,'js_src/');

var devPlugins = [
  new webpack.DefinePlugin({
    'process.env': {
      NODE_ENV: JSON.stringify('development')
    },
  }),
  babelPlugin,
];

var prodPlugins = [
  new webpack.DefinePlugin({
    'process.env': {
      NODE_ENV: JSON.stringify('production')
    },
  }),
  babelPlugin,
  new webpack.DefinePlugin({
    test: /\.jsx?$/,
    use: {
      loader: 'babel-loader',
      options: {
        presets: [
          '@babel/preset-env',
          '@babel/preset-react',
          [
            'minify', {
              builtIns: false,
              evaluate: false,
              mangle: false,
            }
          ]
        ]
      }
    },
 })
];

module.exports = [
  // Dev
  {
    output: {
      path: outputPath,
      filename: 'react_with_addons.js',
    },
    entry: path.resolve(inputPath, 'react.js'),
    plugins: devPlugins,
    mode: 'development',
    externals: [{"window": "window"}]
  },
  {
    output: {
      path: outputPath,
      filename: 'react.js',
    },
    entry: path.resolve(inputPath, 'react.js'),
    plugins: devPlugins,
    mode: 'development',
    externals: [{"window": "window"}]
  },
  {
    output: {
      path: outputPath,
      filename: 'react_dom.js',
    },
    entry: path.resolve(inputPath, 'react_dom.js'),
    plugins: devPlugins,
    mode: 'development',
    externals: [{"window": "window"}]
  },
  {
    output: {
      path: outputPath,
      filename: 'react_dom_server.js',
    },
    entry: path.resolve(inputPath, 'react_dom_server.js'),
    plugins: devPlugins,
    mode: 'development',
    externals: [{"window": "window"}]
  },

  // Prod
  {
    output: {
      path: outputPath,
      filename: 'react_prod.js',
    },
    entry: path.resolve(inputPath, 'react.js'),
    plugins: prodPlugins,
    mode: 'production',
    externals: [{"window": "window"}]
  },
  {
    output: {
        path: outputPath,
        filename: 'react_dom_prod.js',
      },
    entry: path.resolve(inputPath, 'react_dom.js'),
    plugins: prodPlugins,
    mode: 'production',
    externals: [{"window": "window"}]
  },
  {
    output: {
        path: outputPath,
        filename: 'react_dom_server_prod.js',
      },
    entry: path.resolve(inputPath, 'react_dom_server.js'),
    plugins: prodPlugins,
    mode: 'production',
    externals: [{"window": "window"}]
  },
  {
    output: {
      path: outputPath,
      filename: 'react_with_react_dom_prod.js',
    },
    entry: path.resolve(inputPath, 'react_with_react_dom.js'),
    plugins: prodPlugins,
    mode: 'production',
    externals: [{"window": "window"}]
  },
];
