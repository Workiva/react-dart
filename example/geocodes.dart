import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import "dart:html";
import "dart:convert";


class _GeocodesAddress extends react.Component {

  render() {
    return react.tr({}, [
        react.td({}, props['lat']),
        react.td({}, props['lng']),
        react.td({}, props['formatted'])
    ]);
  }
}

var geocodesAddress = react.registerComponent(() => new _GeocodesAddress());


class _GeocodesAddressList extends react.Component {

  render() {
    return react.div({}, react.table({},
      props['data'].map(
        (addr) => geocodesAddress({
          'lat': addr['geometry']['location']['lat'],
          'lng': addr['geometry']['location']['lng'],
          'formatted': addr['formatted_address']
        })
      )
    )); 
  }
}

var geocodesAddressList =
  react.registerComponent(() => new _GeocodesAddressList());


class _GeocodesForm extends react.Component {

  onSubmit(e) {
    e.preventDefault();
    var addr = ref('addressInput').value;
    ref('addressInput').value = "";
    props['submitCallback'](addr);
  }

  render() {
    return react.div({},
      react.form({'onSubmit': onSubmit}, [
        react.input({
          'type': 'text',
          'placeholder': 'Enter address',
          'ref': 'addressInput'
        }),
        react.input({'type': 'submit'}),
      ])
    );
  }
}

var geocodesForm = react.registerComponent(() => new _GeocodesForm());


class _GeocodesApp extends react.Component {

  getInitialState() => {
    'shown_addresses': [],
  };

  newRequest(addr) {

    addr = Uri.encodeQueryComponent(addr);
    var path =
      'https://maps.googleapis.com/maps/api/geocode/json?address=$addr';

    HttpRequest.getString(path)
      .then((String raw) {
        var data = JSON.decode(raw);
        setState({'shown_addresses': data['results']});
      })
      .catchError((Error error) {
        print(error.toString());
      });
  }

  render() {
    return react.div({}, [
        geocodesAddressList({'data': state['shown_addresses']}),
        geocodesForm({'submitCallback': newRequest})
    ]);
  }
}

var geocodesApp = react.registerComponent(() => new _GeocodesApp());


void main() {
  setClientConfiguration();
  react.render(geocodesApp({}), querySelector('#content'));
}