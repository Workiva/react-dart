import { defineConfig } from 'vite'
import { resolve } from 'path'

// https://vite.dev/config/
export default defineConfig({
  mode: process.env.NODE_ENV,
  define: {
    'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV),
  },
  build: {
    outDir: 'lib/js',
    emptyOutDir: false,
    sourcemap: process.env.NODE_ENV == 'production',
    lib: {
      entry: {
        react: resolve(__dirname, 'js_src/index.mjs')
      },
      name: "initReact",
      fileName: (format, entryName) => `${entryName}.${process.env.NODE_ENV == 'production' ? 'min' : 'dev'}.js`,
      formats: ['iife'],
    },
    minify: process.env.NODE_ENV == 'production',
    commonjsOptions: { transformMixedEsModules: true },
    rollupOptions: {
      // make sure to externalize deps that shouldn't be bundled into your library
      external: [
        // `react-redux` requires `redux` but we do not utilize the one section that it is used.
        // For reference, react-redux.js uses `redux` only one time ever, in [whenMapDispatchToPropsIsObject]
        // and it calls `redux.bindActionCreators`.
        //
        // This line fakes any `require('redux')` calls, so that webpack will not include all of the `redux` code.
        'redux',
        'window'
      ],
      output: {
        // Provide global variables to use in the UMD build
        // for externalized deps
        globals: {
          window: 'window',
          // see rollupOptions `external` comment for `redux`.
          redux: 'window.Object',
        },
      },
    },
  },
})
