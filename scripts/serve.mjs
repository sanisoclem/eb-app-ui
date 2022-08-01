import esbuild from "esbuild";
import devServer from "esbuild-plugin-dev-server";

esbuild.build({
  entryPoints: ["./index.js"],
  bundle: true,
  outfile: "./dist/index.js",
  plugins: [devServer({ public: "./dist", port: 3000 })],
});
