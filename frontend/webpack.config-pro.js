if (typeof process.env.ENV === 'undefined') {
  console.error('You need to define $ENV for npm build.');
  process.exit(1);
}

const webpack = require("webpack");
const path = require("path");

const __root = path.resolve(__dirname, "../");
const buildPath = path.resolve(__root, "public", process.env.ENV, "assets");
const nodeModulesPath = path.resolve(__root, "node_modules");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const ManifestPlugin = require("webpack-manifest-plugin");

const configs = [
  {
    mode: "production",
    entry: path.join(__root, "/frontend/javascripts/application.js"),
    devtool: "source-map",
    output: {
      path: buildPath,
      filename: "[name].[hash].js",
    },
    module: {
      rules: [
        {
          test: /\.js?$/,
          loader: "babel-loader",
          exclude: nodeModulesPath
        },
        {
          test: /\.css?$/,
          loader: "style!css",
          query: "sourceMap",
        },
        {
          test: /\.sass?$/,
          use: ExtractTextPlugin.extract({
            fallback: "style-loader",
            use: [
              {
                loader: "css-loader",
                options: { minimize: true, sourceMap: true },
              },
              "sass-loader?sourceMap",
            ]
          }),
        },
        {
          test: /\.(gif|png|jpg|eot|wof|woff|woff2|ttf|svg)$/,
          loader: "url-loader",
        },
      ],
    },
    optimization: {
      noEmitOnErrors: true,
      minimizer: [
        new UglifyJsPlugin(),
      ],
    },
    plugins: [
      new ExtractTextPlugin("[name].[hash].css"),
      new ManifestPlugin(),
      new webpack.ProvidePlugin({
        $: "jquery",
        jQuery: "jquery",
      }),
    ],
    resolve: {
      extensions: [".js", ".jsx"]
    },
    cache: true,
  },
];

module.exports = configs;
