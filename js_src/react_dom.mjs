import ReactDOM from 'react-dom';
import * as ReactRedux from 'react-redux';
import * as ReactDOMTestUtils from 'react-dom/test-utils';

Object.assign(window, {
  ReactDOM,
  ReactRedux,
  'ReactDOMTestUtils': {
    'act': ReactDOMTestUtils.act,
  },
});

if (process.env.NODE_ENV == 'development') {
  import('./react_dom_dev.mjs');
}
