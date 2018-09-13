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
      minimize: true,
    },
    plugins: [
      new ExtractTextPlugin("[name].[hash].css"),
      new ManifestPlugin(),
      new webpack.ProvidePlugin({
        $: "jquery",
        jQuery: "jquery",
      }),
      new webpack.DefinePlugin({
        'process.env': {
          FIREBASE_API_KEY: JSON.stringify(process.env.FIREBASE_API_KEY),
          FIREBASE_AUTH_DOMAIN: JSON.stringify(process.env.FIREBASE_AUTH_DOMAIN),
          FIREBASE_DB_URL: JSON.stringify(process.env.FIREBASE_DB_URL),
          FIREBASE_PROJECT_ID: JSON.stringify(process.env.FIREBASE_PROJECT_ID),
          FIREBASE_STORAGE_BUCKET: JSON.stringify(process.env.FIREBASE_STORAGE_BUCKET),
          FIREBASE_SENDER_ID: JSON.stringify(process.env.FIREBASE_SENDER_ID),
        },
      }),
    ],
    resolve: {
      extensions: [".js", ".jsx"]
    },
    cache: true,
  },
];

module.exports = configs;
