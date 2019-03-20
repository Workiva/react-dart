window._JsFoo = class JsFooComponent extends React.Component {
  render() {
    var foo = this.props.foo;
    var style = this.props.style;
    var onButtonClick = this.props.onButtonClick;
    var rest = Object.assign({}, this.props);
    delete rest.foo;
    delete rest.onButtonClick;

    return React.createElement("div", rest, [
      React.createElement("h4", {}, 'Foo component'),
      React.createElement("p", {}, 'value of props.foo: ', foo),
      React.createElement("button", {onClick: onButtonClick}, 'button'),
      rest.children,
    ]);
  }
  getFoo() {
    return this.props.foo;
  }
};
