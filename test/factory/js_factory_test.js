window._JsFoo = class JsFooComponent extends React.Component {
  render() {
    return React.createElement("div", this.props, this.props.children);
  }
};

window._JsFooFunction = React.forwardRef((props, ref) => (
  React.createElement("div", {...props, ref: ref})
));

window._JsNoChildren = class JsNoChildrenComponent extends React.Component {
  render() {
    if(this.props.children !== undefined) {
      throw Error('children prop must be undefined');
    }

    return React.createElement("div", this.props);
  }
};
