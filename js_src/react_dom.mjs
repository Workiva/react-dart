import ReactDOM from 'react-dom';
import { createRoot } from 'react-dom/client';
import * as ReactRedux from 'react-redux';

globalThis.ReactDOM = {
    ...ReactDOM,
    // Import createRoot from react-dom/client to avoid the warning about ReactDOM.createRoot.
    createRoot,
  };
globalThis.ReactRedux = ReactRedux;

if (process.env.NODE_ENV == 'development') {
  import('./react_dom_dev.mjs');
}
