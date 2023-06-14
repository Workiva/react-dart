import { defineConfig } from 'tsup'

export default defineConfig({
  format: ['esm'],
  target: 'es5',
  outExtension({ format }) {
    return {
      js: format === 'esm' ? '.esm.js' : '.js',
    };
  },
  outDir: './lib',
  entry: ['js_src/react_with_react_dom.js'],
  noExternal: [/.*/],
  platform: 'browser',
  splitting: false,
})