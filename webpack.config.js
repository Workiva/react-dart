const webpack = require('webpack');
const path = require('path');
const outputPath = path.resolve(__dirname, 'lib/');
const inputPath = path.resolve(__dirname, 'js_src/');

var babelRules = [
  {
    test: /\.js?$/,
    use: {
      loader: 'babel-loader',
      options: {
        exclude: [/node_modules/],
        presets: [
          [
            '@babel/preset-env',
            {
              corejs: 3,
              useBuiltIns: 'usage',
              targets: {
                browsers: 'last 2 chrome versions, last 2 edge versions, ie 11',
              },
            },
          ],
        ],
      },
    },
  },
];

/// Helper function that generates the webpack export objects array
///
/// Usage:
/// createExports([
///   [entryFilename, outputFilename, [isProduction]],
///   {
///   ...NORMAL WEBPACK CONFIG OBJECT...
///   },
///   ...
/// ]);
///
function createExports(exportMappings) {
  exportObjects = [];
  exportMappings.forEach(function(mapping) {
    if (Array.isArray(mapping)) {
      entryFilename = mapping[0];
      outputFilename = mapping[1] || mapping[0];
      isProduction = mapping[2] || outputFilename.includes('_prod');
      includeReact = entryFilename === 'react.js' || entryFilename.includes('react_with');
      exportObject = {
        ...(entryFilename.includes('profiling') && {
          resolve: {
            // ...
            alias: {
              // ...
              'react-dom$': 'react-dom/profiling',
              'scheduler/tracing': 'scheduler/tracing-profiling',
            },
            // ...
          },
        }),
        output: {
          path: outputPath,
          filename: outputFilename,
        },
        module: {
          rules: babelRules,
        },
        entry: path.resolve(inputPath, entryFilename),
        mode: isProduction ? 'production' : 'development',
        externals: [{ window: 'window' }],
        devtool: 'source-map',
      };

      // `react-redux` requires `redux` but we do not utilize the one section that it is used.
      // For reference, react-redux.js uses `redux` only one time ever, in [whenMapDispatchToPropsIsObject]
      // and it calls `redux.bindActionCreators`.
      //
      // This line fakes any `require('redux')` calls, so that webpack will not include all of the `redux` code.
      exportObject.externals[0].redux = 'window.Object';

      if (!includeReact) {
        // This forces any packages that require react as a dependacy to have the same instance of react that
        // is provided by our react js bundles.
        exportObject.externals[0].react = 'window.React';

        // Re-uses React.PropTypes setup in react.js instead of including the entire lib again.
        exportObject.externals[0]['prop-types'] = 'window.React.PropTypes';
      }
      exportObjects.push(exportObject);
    } else {
      exportObjects.push(mapping);
    }
  });
  return exportObjects;
}

module.exports = createExports([
  ['react.js', 'react_with_addons.js'],
  ['react.js', 'react.js'],
  ['react_dom.js', 'react_dom.js'],
  ['react_dom_server.js', 'react_dom_server.js'],
  ['react.js', 'react_prod.js'],
  ['react_dom.js', 'react_dom_prod.js'],
  ['react_dom_server.js', 'react_dom_server_prod.js'],
  ['react_with_react_dom.js', 'react_with_react_dom_prod.js'],
  ['react_with_react_dom_profiling.js', 'react_with_react_dom_prod_profiling.js'],
]);
