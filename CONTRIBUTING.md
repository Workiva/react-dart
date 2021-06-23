## Contributing Guide

### How to bundle a custom version of React JS

Sometimes, you want to pull in a specific branch of React JS for testing.

To do so, start by cloning [facebook/react](https://github.com/facebook/react), and check out the branch you want to pull in.

Then, follow React's ["Development Workflow" guide](https://reactjs.org/docs/how-to-contribute.html#development-workflow), following the steps for "If your project uses React from npm". **tl;dr:** build React and link it to react-dart:
```sh
cd ~/path/to/react/
yarn build --type=NODE

(cd build/node_modules/react && yarn link)
(cd build/node_modules/react-dom && yarn link)

cd ~/path/to/react-dart
yarn link react react-dom
```

Finally, build react-dart's bundle:
```sh
yarn build
```
and commit the updated JS files in `lib/`.
