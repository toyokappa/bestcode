const webpack = require("webpack");
const path = require("path");

const __root = path.resolve(__dirname, "../");
const buildPath = path.resolve(__root, "public", "assets");
const nodeModulesPath = path.resolve(__root, "node_modules");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const ManifestPlugin = require("webpack-manifest-plugin");

const configs = [
  {
    mode: "development",
    entry: path.join(__root, "/frontend/javascripts/application.js"),
    output: {
      path: buildPath,
      filename: "[name].js",
      publicPath: "http://0.0.0.0:3333/",
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
          loaders: ["style-loader", "css-loader", "sass-loader"],
        },
        {
          test: /\.(gif|png|jpg|eot|wof|woff|woff2|ttf|svg)$/,
          loader: "url-loader",
        },
      ],
    },
    devServer: {
      contentBase: "public",
      hot: true,
      inline: true,
      port: 3333,
      host: "0.0.0.0",
      stats: "errors-only",
      headers: { "Access-Control-Allow-Origin": "*" },
      disableHostCheck: true,
    },
    optimization: {
      noEmitOnErrors: true,
    },
    plugins: [
      new webpack.HotModuleReplacementPlugin(),
      new ExtractTextPlugin("[name].css"),
      new ManifestPlugin(),
      new webpack.ProvidePlugin({
        $: "jquery",
        jQuery: "jquery",
      }),
    ],
    resolve: {
      extensions: [".js", ".jsx"]
    },
  },
];

module.exports = configs;