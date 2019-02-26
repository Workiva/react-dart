const webpack = require("webpack");
const path = require("path");
const UglifyJsPlugin = require("uglifyjs-webpack-plugin");

const outputPath = path.resolve(__dirname, "lib/");
const inputPath = path.resolve(__dirname, "js_src/");


var babelPlugin = new webpack.DefinePlugin({
  test: /\.jsx?$/,
  use: {
    loader: "babel-loader",
    options: {
      presets: ["@babel/preset-env", "@babel/preset-react"]
    }
  }
});

var devPlugins = [
  babelPlugin,
];

var prodPlugins = [
  babelPlugin,
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
      exportObjects.push(
        {
          output: {
            path: outputPath,
            filename: outputFilename
          },
          entry: path.resolve(inputPath, entryFilename),
          plugins: isProduction ? prodPlugins : devPlugins,
          mode: isProduction ? "production" : "development",
          externals: [{ window: "window" }],
          devtool: "source-map",
        }
      );
    } else {
      exportObjects.push(mapping);
    }
  });
  return exportObjects;
}

module.exports = createExports(
    [
      ["react.js",                "react_with_addons.js"],
      ["react.js",                "react.js"],
      ["react_dom.js",            "react_dom.js"],
      ["react_dom_server.js",     "react_dom_server.js"],
      ["react.js",                "react_prod.js"],
      ["react_dom.js",            "react_dom_prod.js"],
      ["react_dom_server.js",     "react_dom_server_prod.js"],
      ["react_with_react_dom.js", "react_with_react_dom_prod.js"],
    ]
  );
