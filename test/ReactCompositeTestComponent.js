function compositeComponent() {
  return class ReactCompositeTestComponent extends React.Component {
    render(){
      return React.createElement("div", {}, 'test js component');
    }
  }
}
