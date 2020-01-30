window._JsFoo = class JsFooComponent extends React.Component {
  render() {
    return React.createElement("div", this.props, this.props.children);
  }
};

window._JsFooFunction = React.forwardRef((props, ref) => (
  React.createElement("div", {...props, 'ref': ref, 'onClick': function(event) {
    if (props['onClickJs'] !== undefined) {
      props['onClickJs'](event);
    }

    if (props['onClick'] !== undefined) {
      props['onClick'](event);
    }
  }}, React.createElement("div", {'ref': props['innerRef']}, props['children']))
));
