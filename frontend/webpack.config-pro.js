// TODO: 本番環境用は完全なセットアップができていないためデプロイをするタイミングで設定が必要
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
      minimize: true,
    },
    plugins: [
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
