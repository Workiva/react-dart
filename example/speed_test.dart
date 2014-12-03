import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import "dart:html";
import "dart:async";

Stopwatch stopwatch = new Stopwatch()..start();
timeprint(message){
  print("$message ${stopwatch.elapsedMilliseconds}");
  stopwatch.reset();
}


class _Div extends react.Component{

  shouldComponentUpdate(nProps, nState){
    return nProps['key'] != props['key'];
  }

  render(){
    return react.div(props, props['children']);
  }
}

var Div = react.registerComponent(() => new _Div());

class _Span extends react.Component{

  shouldComponentUpdate(nProps, nState){
    return nProps['children'][0] != props['children'][0];
  }

  render(){
    return react.span(props, props['children']);
  }
}

var Span = react.registerComponent(() => new _Span());

class _Hello extends react.Component {

  componentWillMount(){
    new Future.delayed(new Duration(seconds: 5), (){
      stopwatch.reset();
      timeprint('before redraw call');
      redraw();
      timeprint('after redraw call');
    });
  }

  void redraw(){
    setState({});
  }

  render() {
    timeprint("rendering start");
    List<List<String>> data = props['data'];
    var children = [];
    for(var elem in data){
      children.add(
          react.div({'key': elem[0]},[
            react.span({}, elem[0]),
            " ",
            react.span({}, elem[1])
          ])
      );
    }
//    data.forEach((elem) => children.add(
//        react.div({'key': elem[0]},[
//          react.span({}, elem[0]),
//          " ",
//          react.span({}, elem[1])
//        ]))
//    );
    timeprint("rendering almost ends");
    var res = react.div({}, children);
    timeprint("rendering ends");
    return res;
  }
}

var Hello = react.registerComponent(() => new _Hello());

void main() {
  setClientConfiguration();
  var data=[];
  for(num i=0; i<1000; i++){
    data.add(["name_$i", "value_$i"]);
  }
  react.render(Hello({"data": data}, []), querySelector('#content'));
}