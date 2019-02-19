window._JsFoo = React.createClass({
  render: function() {
    return React.DOM.div(this.props, this.props.children);
  }
});
