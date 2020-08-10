window._JsFoo = class JsFooComponent extends React.Component {
  render() {
    return React.createElement("div", this.props, this.props.children);
  }
};

window._JsFooFunction = React.forwardRef((props, ref) => (
  React.createElement("div", {...props, ref: ref})
));
