var Foo = React.createClass({
  render: function() {
    // Equivalent to ES6:
    //    var {foo, onButtonClick, ...rest} = this.props;
    var foo = this.props.foo;
    var onButtonClick = this.props.onButtonClick;
    var rest = Object.assign({}, this.props);
    delete rest.foo;
    delete rest.onButtonClick;

    return React.DOM.div(rest,
        React.DOM.h4({}, 'Foo component'),
        React.DOM.p({}, 'value of props.foo: ', foo),
        React.DOM.button({onClick: onButtonClick}, 'button')
    )
  },

  getFoo: function() {
    return this.props.foo;
  }
});

window.Foo = Foo;
