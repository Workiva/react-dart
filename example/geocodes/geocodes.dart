import "package:react/react.dart" as react;
import "package:react/react_dom.dart" as reactDom;
import "package:react/react_client.dart";
import "dart:html";
import "dart:convert";
import "dart:async";

/*
 * Hello,
 *
 * this is a part of the tutorial to the react-dart package. We'll go through
 * a simple app that is quering Google Maps API and showing the result to the
 * user. It also stores the search history and allows to reload past queries.
 *
 * In this file you'll find the structure and the logic of the app.
 * There is also a `geocodes.html` file, that contains the mountpoint.
 *
 * Be sure that you understand the basic concepts of
 * [React](http://facebook.github.io/react/) before reading this tutorial.
 *
 * Enjoy!
 */


/*
 * Divide your app to the components and conquer!
 * There is a first custom component. It is just a table row showing
 * one item of the response to the user.
 */
class _GeocodesResultItem extends react.Component {

  /*
   * The only function you must implement in the custom component is `render`.
   * It just returns the the structure of the other components.
   *
   * Every component has a map of properties called `props`. It can be
   * specified during creation.
   */
  render() {
    return react.tr({}, [
      react.td({}, props['lat']),
      react.td({}, props['lng']),
      react.td({}, props['formatted'])
    ]);
  }
}

/*
 * Now we need to tell React that there exists our custom component.
 * As a reward, it gives us a function, that takes the properties
 * and returns our element. You'll see it in action shortly.
 * It is the only correct way to create your component. Do not use the
 * constructor!
 */
var geocodesResultItem =
  react.registerComponent(() => new _GeocodesResultItem());


/*
 * In this component we'll
 */
class _GeocodesResultList extends react.Component {

  render() {
    /*
     * Built-in components have also properties.
     * They correspond to the html props.
     */
    return react.div({'id': 'results'}, [
      react.h2({}, "Results:"),
      /*
       * However, `class` is a keyword in javascript, therefore
       * `className` is used instead
       */
      react.table({'className': 'table'}, [
        react.thead({}, [
          react.th({}, 'Latitude'),
          react.th({}, 'Longitude'),
          react.th({}, 'Address')
        ]),
        react.tbody({},
          /*
           * The second argument contains the body of the component
           * (as you have already seen). It can be a string,
           * a component or an iterable.
           */
          props['data'].map(
            // Usecase for our custom component.
            (item) => geocodesResultItem({
              'lat': item['geometry']['location']['lat'],
              'lng': item['geometry']['location']['lng'],
              'formatted': item['formatted_address']
            })
          )
        )
      ])
    ]);
  }
}

var geocodesResultList =
  react.registerComponent(() => new _GeocodesResultList());


/*
 * On the search form is ilustrated that:
 *  - the functions can be component parameters (handy for callbacks)
 *  - the DOM elements can accessed using refs.
 */
class _GeocodesForm extends react.Component {

  render() {
    return react.div({}, [
      react.h2({}, "Search"),
      // Component function is passed as callback
      react.form({'onSubmit': onFormSubmit}, [
        react.input({
          'type': 'text',
          'placeholder': 'Enter address',
          // Input is referenced to access it's value
          'ref': 'addressInput'
        }),
        react.input({'type': 'submit'}),
      ])
    ]);
  }

  // This is called when form is submited
  onFormSubmit(e) {
      e.preventDefault();
      InputElement inputElement = reactDom.findDOMNode(ref('addressInput'));
      // The input's value is accessed.
      var addr = inputElement.value;
      inputElement.value = "";
      // And the callback from the parent element is called.
      // (Yes, you haven't seen it yet.)
      props['submiter'](addr);
    }
}

var geocodesForm = react.registerComponent(() => new _GeocodesForm());

/*
 * Nothing new here. Item in history list.
 */
class _GeocodesHistoryItem extends react.Component {

  reload(e) {
    props['reloader'](props['query']);
  }

  render() {
    return react.li({}, [
      react.button({'onClick': reload}, 'Reload'),
      " (${props['status']}) ${props['query']}"
    ]);
  }
}

var geocodesHistoryItem =
  react.registerComponent(() => new _GeocodesHistoryItem());


/*
 * And the whole history list. Note, that it just
 * passes the callback from the parent.
 */
class _GeocodesHistoryList extends react.Component {

  render() {
    return react.div({}, [
      react.h3({}, "History:"),
      react.ul({},
        new List.from(props['data'].keys.map(
          (key) => geocodesHistoryItem({
            'key': key,
            'query': props['data'][key]["query"],
            'status': props['data'][key]["status"],
            'reloader': props['reloader']
          })
        )).reversed
      )
    ]);
  }
}

var geocodesHistoryList =
  react.registerComponent(() => new _GeocodesHistoryList());


/*
 * The core component of the App.
 *
 * Introduces the state. State and the properties are the two places to store
 * the component's data. However they differ in the use:
 *  - the properties contain data dictated by the parent component
 *  - the state is an internal storage of the component that can't
 *    be accessed by the parent. When the state is changed,
 *    the whole component is repainted.
 *
 * It's a common practice to store the aplication data in the state of the
 * root component. It will redpaint every time, the state is changed. However,
 * it is not required - you can use normal variables and repaint manualy.
 *
 * When the request is sent, it has `pending` status in the history.
 * This changes to `OK` or `error` when the answer (or timeout) comes.
 * If the new request is sent meanwhile, the old one is `canceled`.
 */
class _GeocodesApp extends react.Component {

  getInitialState() => {
    'shown_addresses': [], // Data from last query.
    'history': {} // Map of past queries.
  };

  var last_id = 0; // The id of the last query.

  /*
   * Sends the query to the API and processes the result
   */
  newQuery(String addr) {

    /*
     * Once the query is being sent, it appears in the history
     * and is given an id.
     */
    var id = addQueryToHistory(addr);

    // Prepare the URL
    addr = Uri.encodeQueryComponent(addr);
    var path =
      'https://maps.googleapis.com/maps/api/geocode/json?address=$addr';

    // Send the request
    HttpRequest.getString(path)
      .then((value) =>
        // Delay the answer 2 more seconds, for the test purposes
        new Future.delayed(new Duration(seconds:2), ()=>value)
      )
      .then((String raw) {
        // Is this the answer to the last request?
        if(id == last_id){
          // If yes, query was `OK` and `shown_adresses` are replaced
          state['history'][id]['status']='OK';
          var data = JSON.decode(raw);
          /*
           * Calling `setState` will update the state and then
           * repaint the component.
           *
           * In theory, state should be considered as immutable
           * and `setState` or `replaceState` should be the only way
           * to change it.
           *
           * It is possible to do this, when the whole state value is parsed
           * from the server response (the case of `shown_addresses`).
           * However, it would be inefficient to copy whole `history` just to
           * change one item. Therefore we mutate it and then
           * replace it by itself.
           *
           * Have a look at vacuum_persistent package to achieve
           * the immutability of state.
           */
          setState({
            'shown_addresses': data['results'],
            'history': state['history']
          });
        } else {
          // Otherwise, query was `canceled`
          state['history'][id]['status']='canceled';
          setState({'history': state['history']});
        }
      })
      .catchError((Error error) {
        state['history'][id]['status']='error';
        setState({'history': state['history']});
      });
  }

  /*
   * Add a new query to the history with the `pending` state,
   * and return it's id.
   */
  addQueryToHistory(String query) {
    var id = ++last_id;
    state['history'][id] = {
      "query": query,
      "status": "pending"
    };
    setState({'history': state['history']});
    return id;
  }

  render() {
    return react.div({}, [
        react.h1({}, "Geocode resolver"),
        geocodesResultList({
          // The state values are passed to the children as the properties.
          'data': state['shown_addresses']
        }),
        geocodesForm({
          // `newQuery` is the final callback of the button presses.
          'submiter': newQuery
        }),
        geocodesHistoryList({
          'data': state['history'],
          // The same here.
          'reloader': newQuery
        })
    ]);
  }
}

var geocodesApp = react.registerComponent(() => new _GeocodesApp());

/*
 * And, finally, few magic commands to make it work!
 *
 * Select the root of the app and the place, where it lives.
 */
void main() {
  setClientConfiguration();
  reactDom.render(geocodesApp({}), querySelector('#content'));
}
