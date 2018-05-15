const ExtractTextPlugin = require("extract-text-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const elmSource = __dirname + "/elm";
const env = process.env.MIX_ENV || "dev";
const isProduction = env === "prod";
const path = require("path");

module.exports = {
  devtool: "source-map",
  entry: {
    app: ["./js/app.js", "./elm/Main.elm"]
  },
  output: {
    path: path.resolve(__dirname, "../priv/static/"),
    filename: "js/app.js"
  },
  resolve: {
    extensions: [".css", ".scss", ".js", ".elm"],
    alias: {
      phoenix: __dirname + "/deps/phoenix/assets/js/phoenix.js"
    }
  },
  module: {
    rules: [
      {
        test: /\.(sass|scss)$/,
        include: /css/,
        use: ExtractTextPlugin.extract({
          fallback: "style-loader",
          use: [
            { loader: "css-loader" },
            {
              loader: "sass-loader",
              options: {
                sourceComments: !isProduction
              }
            }
          ]
        })
      },
      {
        test: /\.(js)$/,
        include: /js/,
        use: [{ loader: "babel-loader" }]
      },
      {
        test: /\.elm$/,
        exclude: ["/elm-stuff/", "/node_modules"],
        loader: "elm-webpack-loader",
        options: { maxInstances: 2, debug: true, cwd: elmSource }
      }
    ],
    noParse: [/\.elm$/]
  },
  plugins: [
    new ExtractTextPlugin("css/app.css"),
    new CopyWebpackPlugin([{ from: "./static" }])
  ]
};
