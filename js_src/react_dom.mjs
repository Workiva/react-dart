import ReactDOM from 'react-dom';
import * as ReactRedux from 'react-redux';

Object.assign(globalThis, {
  ReactDOM,
  ReactRedux,
});

if (process.env.NODE_ENV == 'development') {
  import('./react_dom_dev.mjs');
}
