import { defineConfig } from 'tsup'

export default defineConfig({
  format: ['esm'],
  target: 'es5',
  outExtension() {
    return { js: '.js' };
  },
  outDir: './lib',
  entry: ['js_src/react_with_react_dom.esm.js'],
  noExternal: [/.*/],
  platform: 'browser',
  splitting: false,
})