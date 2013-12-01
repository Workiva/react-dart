// Copyright (c) 2013, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library react_server;

import "package:react/react.dart";
import "dart:math";

/**
 * important constants geted from react.js needed to create correct checksum
 */
String _SEPARATOR = ".";
String _ID_ATTR_NAME = "data-reactid";
String _CHECKSUM_ATTR_NAME = "data-react-checksum";
num    _GLOBAL_MOUNT_POINT_MAX = 9999999;
num    _MOD = 65521;



typedef String OwnerFactory([String ownerId, num position, String key]);
typedef OwnerFactory ReactComponentFactory(Map props, [dynamic children]);
typedef Component ComponentFactory();

/**
 * register component will create method, which create new Component,
 * run lifecycle methods and return it's render method result
 */
ReactComponentFactory _registerComponent(ComponentFactory componentFactory) {
  /**
   * return ReactComponentFactory which produce react component with seted props and
   * children[s] and return it's render method result
   */
  return (Map props, [dynamic children]) {
    Component component = componentFactory();

    /**
     * get default props, add children to props and apply props from arguments
     */
    component.props = component.getDefaultProps();
    component.props["children"] = children;
    component.props.addAll(props);

    /**
     * get initial state and run componentWillMount lifecycle method
     */
    component.state = component.getInitialState();
    component.componentWillMount();

    /**
     * if component will mount called setState or replaceState, then transfer this state to actual state.
     */
    if (component.nextState != null) {
      component.transferComponentState();
    }

    /**
     * return component render method result. (it should be string)
     */
    return ([String ownerId, num position, String key]) {return component.render()(ownerId, position, key);};
  };

}



/**
 * create basic dom component factory
 */
ReactComponentFactory _reactDom(String name) {
  return (Map args, [children]) {
    /**
     * pack component string creating into function to easy pass owner id,
     * position and key (from its' custom component owner)
     */
    return ([String ownerId, num position, String key]) {
      /**
       * unpair elements can't have children
       */
      if (_unPairElements.contains(name) && (children != null && children.length > 0)) {
        throw new Exception();
      }

      /**
       * count react id
       *
       * if args contains key, then replace argument key by that key.
       */
      if (args.containsKey("key")) {
        key = args["key"].toString();
      }

      /**
       * if ownerId is not set, than this is root and create rootId to it.
       */
      String thisId;
      if (ownerId == null) {
        thisId = _createRootId();
      } else {
        /**
         * else append adequate string to parent id based on position and key.
         */
        thisId = ownerId + (key != null ? ".{$key}" : (position != null ? ".[$position]" : ".[0]"));
      }

      /**
       * convert args to eliminate event handlers
       *
       * return false on that event
       */
      _convertDomArguments(args);

      /**
       * convert bound values to only that values
       */
      _convertBoundValues(args);


      /**
       * create stringbuffer to build result
       *
       * end open tag to it
       */
      StringBuffer result = new StringBuffer("<$name");

      /**
       * add attributes to it
       */
      args.forEach((String key, value) {
        result.write(" ${key.toLowerCase()}=\"$value\"");
      });

      /**
       * add id after attributes
       */
      result.write(' $_ID_ATTR_NAME="$thisId"');

      /**
       * if element is not pair, then close it
       */
      if (_unPairElements.contains(name)) {
        result.write(">");
      } else {
        /**
         * close open tag
         */
        result.write(">");

        /**
         * add children (if children is list)
         */
        if (children is List) {
          for(num i = 0; i < children.length; ++i) {
            var component = children[i];
            if (component is String) {
              result.write(span({}, component)(thisId, i));
            } else {
              result.write(component(thisId, i));
            }
          }
        } else if (children != null) {
          /**
           * or child (if childre is not list and not null
           *
           * if it is string, add it as it is, if not, add it as component
           */
          if (children is String) {
            result.write(children);
          } else {
            result.write(children(thisId, i));
          }
        }
        /**
         * and add close tag
         */
        result.write("</$name>");
      }

      /**
       * return result as strin
       */
      return result.toString();
    };
  };
}

/**
 * convert DOM arguments (delete event handlers and key)
 */
_convertDomArguments(Map args) {
  /**
   * synthetic events must not pass to string and key too
   */
  _syntheticEvents.forEach((key) => args.remove(key));
  args.remove("key");

  /**
   * change "className" for class
   */
  if (args.containsKey("className")) {
    args["class"] = args["className"];
    args.remove("className");
  }

  /**
   * change "htmlFor" for "for"
   */
  if (args.containsKey("htmlFor")) {
    args["for"] = args["htmlFor"];
    args.remove("htmlFor");
  }


}

/**
 * convert bound values to only values
 */
_convertBoundValues(Map args) {
  if (args['value'] is List) {
    args['value'] = args['value'][0];
  }
}

/**
 * set of all in client converted synthetic events
 */
Set _syntheticEvents = new Set.from(["onCopy", "onCut", "onPaste",
    "onKeyDown", "onKeyPress", "onKeyUp", "onFocus", "onBlur",
    "onChange", "onInput", "onSubmit", "onClick", "onDoubleClick",
    "onDrag", "onDragEnd", "onDragEnter", "onDragExit", "onDragLeave",
    "onDragOver", "onDragStart", "onDrop", "onMouseDown", "onMouseEnter",
    "onMouseLeave", "onMouseMove", "onMouseUp", "onTouchCancel", "onTouchEnd",
    "onTouchMove", "onTouchStart", "onScroll", "onWheel",]);

/**
 * set of al pair elements tags ( which are not void elements )
 */
Set _pairElements = new Set.from(["a", "abbr", "address", "article", "aside", "audio",
    "b", "bdi", "bdo", "big", "blockquote", "body", "button", "canvas", "caption",
    "cite", "code", "colgroup", "data", "datalist", "dd", "del", "details", "dfn",
    "div", "dl", "dt", "em", "fieldset", "figcaption", "figure", "footer", "form",
    "h1", "h2", "h3", "h4", "h5", "h6", "head", "header", "html", "i", "iframe",
    "ins", "kbd", "label", "legend", "li", "main", "map", "mark", "menu", "menuitem",
    "meter", "nav", "noscript", "object", "ol", "optgroup", "option", "output", "p",
    "pre", "progress", "q", "rp", "rt", "ruby", "s", "samp", "script", "section",
    "select", "small", "span", "strong", "style", "sub", "summary", "sup", "table",
    "tbody", "td", "textarea", "tfoot", "th", "thead", "time", "title", "tr", "u",
    "ul", "variable", "video",
    /** SVG elements */
    "g", "svg", "text"]);

/**
 * set of empty elements tags based on http://www.w3.org/TR/html-markup/syntax.html#void-element
 */
Set _unPairElements = new Set.from(["area", "base", "br", "col", "hr", "img", "input", "link",
    "meta", "param", "command", "embed", "keygen", "source","track", "wbr",
    /** SVG elements */
    "circle",  "line", "path", "polyline", "rect",]);


/**
 * render component method
 */
String _renderComponentToString(OwnerFactory component) {
  return _addChecksumToMarkup(component());
}

/**
 * creates random id based on id creation in react.js
 */
String _createRootId() {
  var rng = new Random();
  return "${_SEPARATOR}r[${rng.nextInt(_GLOBAL_MOUNT_POINT_MAX).toRadixString(36)}]";
}

/**
 * count checksumm and add it to markup as last attribute of root element
 */
String _addChecksumToMarkup(String markup) {
  var checksum = _adler32(markup);
  return markup.replaceFirst(
      '>',
      ' $_CHECKSUM_ATTR_NAME="$checksum">'
    );

}

/**
 * checksum algorithm copied from react.js
 * ( must be the same to enable react.js recognize it as ok)
 */
_adler32(String data) {
  num a = 1;
  num b = 0;
  for (var i = 0; i < data.length; i++) {
    a = (a + data.codeUnitAt(i)) % _MOD;
    b = (b + a) % _MOD;
  }
  return a | b << 16;
}

void setServerConfiguration() {
  setReactConfiguration(_reactDom, _registerComponent, null, _renderComponentToString);
}
