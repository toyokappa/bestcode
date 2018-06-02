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
    devtool: "source-map",
    output: {
      path: buildPath,
      filename: "[name].js",
      publicPath: "/",
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
    devServer: {
      contentBase: path.join(__root, "public"),
      hot: true,
      inline: true,
      port: 3333,
      host: "localhost",
    },
    optimization: {
      noEmitOnErrors: true,
      minimize: true,
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
