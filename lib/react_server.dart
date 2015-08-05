// Copyright (c) 2013, the Clean project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library react_server;

import "package:react/react.dart";
import "dart:math";
import "package:quiver/iterables.dart";
import 'dart:typed_data';

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
ReactComponentFactory _registerComponent(ComponentFactory componentFactory, [Iterable<String> skipMethods = const []]) {
  /**
   * return ReactComponentFactory which produce react component with seted props and
   * children[s] and return it's render method result
   */
  return (Map props, [dynamic children]) {
    Component component = componentFactory();

    /**
     * get default props, add children to props and apply props from arguments
     */
    props['children'] = children;
    component.initComponentInternal(props, () {});

    /**
     * get initial state and run componentWillMount lifecycle method
     */
    component.initStateInternal();
    component.componentWillMount();

    /**
     * if component will mount called setState or replaceState, then transfer
     * this state to actual state.
     */
    component.transferComponentState();

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
    return ([String ownerId, int position, String key]) {
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
        thisId = ownerId + (key != null ? ".\$$key" : (position != null ? ".${position.toRadixString(36)}" : ".0"));
      }

      /**
       * create stringbuffer to build result
       *
       * end open tag to it
       */
      StringBuffer result = new StringBuffer("<$name");

      /**
       * add attributes to it and prepare args to be
       * same as in react.js
       */
      args.forEach((key,value) {
        String toWrite = _parseDomArgument(key, value);
        if(toWrite != null) result.write(toWrite);
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
        if (children is Iterable) {
          enumerate(children.where((child) => child!=null)).forEach((value) {
            num i = value.index;
            var component = value.value;
            if (component is String) {
              result.write(span({}, component)(thisId, i));
            } else {
              result.write(component(thisId, i));
            }
          });
        } else if (children != null) {
          /**
           * or child (if childre is not list and not null
           *
           * if it is string, add it as it is, if not, add it as component
           */
          if (children is String) {
            result.write(_escapeTextForBrowser(children));
          } else if (children is Function) {
            result.write(children(thisId, 0));
          } else {
            result.write(children);
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
String _parseDomArgument(String key, dynamic value) {
  if(value == null) return '';
  /**
   * synthetic events must not pass to string and key too
   */
  if(_syntheticEvents.contains(key)) return null;
  if(key == 'key') return null;
  if(key == 'ref') return null;

  /**
   * change "className" for class
   */
  if (key == "className") {
    key = 'class';
  }

  /**
   * change "htmlFor" for "for"
   */
  if (key == "htmlFor") {
    key = 'for';
  }

  if (key == "style" && value is Map) {
    Map style = value;
    value = style.keys.map((key) => "$key:${style[key]};").join("");
  }

  if(key == 'value' && value is List) {
    value = value[0];
    if (value is! String) value = value.toString();
  }

  value = _escapeTextForBrowser(value);
  return " ${key.toLowerCase()}=\"${value}\"";
}

var _ESCAPE_LOOKUP = {
  "&": "&amp;",
  ">": "&gt;",
  "<": "&lt;",
  "\"": "&quot;",
  "'": "&#x27;",
  "/": "&#x2f;"
};

var _ESCAPE_REGEX = new RegExp('[&><\\\'/]');

String _escaper(Match match) {
  return _ESCAPE_LOOKUP[match.group(0)];
}

/**
 * Escapes text to prevent scripting attacks.
 * Same as in react.js
 *
 * @param {*} text Text value to escape.
 * @return {string} An escaped string.
 */
String _escapeTextForBrowser(text) {
  return ('' + text).replaceAllMapped(_ESCAPE_REGEX, _escaper);
}

/**
 * set of all in client converted synthetic events
 */
Set _syntheticEvents = new Set.from(["onCopy", "onCut", "onPaste",
    "onKeyDown", "onKeyPress", "onKeyUp", "onFocus", "onBlur",
    "onChange", "onInput", "onSubmit", "onClick", "onDoubleClick",
    "onDrag", "onDragEnd", "onDragEnter", "onDragExit", "onDragLeave",
    "onDragOver", "onDragStart", "onDrop", "onMouseDown", "onMouseEnter",
    "onMouseLeave", "onMouseMove", "onMouseOut", "onMouseOver", "onMouseUp",
    "onTouchCancel", "onTouchEnd", "onTouchMove", "onTouchStart", "onScroll",
    "onWheel",]);

/**
 * set of al pair elements tags ( which are not void elements )
 */
Set _pairElements = new Set.from(["a", "abbr", "address", "article", "aside", "audio",
    "b", "bdi", "bdo", "big", "blockquote", "body", "button", "canvas", "caption",
    "cite", "code", "colgroup", "data", "datalist", "dd", "del", "details", "dfn",
    "dialog", "div", "dl", "dt", "em", "fieldset", "figcaption", "figure", "footer",
    "form", "h1", "h2", "h3", "h4", "h5", "h6", "head", "header", "html", "i", "iframe",
    "ins", "kbd", "label", "legend", "li", "main", "map", "mark", "menu", "menuitem",
    "meter", "nav", "noscript", "object", "ol", "optgroup", "option", "output", "p",
    "picture", "pre", "progress", "q", "rp", "rt", "ruby", "s", "samp", "script", "section",
    "select", "small", "span", "strong", "style", "sub", "summary", "sup", "table",
    "tbody", "td", "textarea", "tfoot", "th", "thead", "time", "title", "tr", "u",
    "ul", "variable", "video",
    /** SVG elements */
    "defs", "g", "linearGradient", "mask", "pattern", "radialGradient", "svg", "text",
    "tspan",]);

/**
 * set of empty elements tags based on http://www.w3.org/TR/html-markup/syntax.html#void-element
 */
Set _unPairElements = new Set.from(["area", "base", "br", "col", "hr", "img", "input", "link",
    "meta", "param", "command", "embed", "keygen", "source","track", "wbr",
    /** SVG elements */
    "circle", "ellipse", "line", "path", "polygon", "polyline", "rect", "stop",]);


/**
 * render component method
 */
String _renderComponentToString(OwnerFactory component) {
  return _addChecksumToMarkup(component());
}

String _renderToStaticMarkup(OwnerFactory component) {
  return _removeReactIdFromMarkup(component());
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

String _removeReactIdFromMarkup(String markup) {
  var matcher = new RegExp(' $_ID_ATTR_NAME=".+?"');
  return markup.replaceAll(matcher, "");
}

/**
 * checksum algorithm copied from react.js
 * ( must be the same to enable react.js recognize it as ok)
 * javacript uses 4-byte signed integers for binary operations
 * while dart adjusts it, so Int32x4 is used for it
 */
_adler32(String data) {
  int a = 1;
  int b = 0;
  for (var i = 0; i < data.length; i++) {
    a = (a + data.codeUnitAt(i)) % _MOD;
    b = (b + a) % _MOD;
  }
  var A = new Int32x4(a, 0, 0, 0);
  var B = new Int32x4(b << 16, 0, 0, 0);
  return (A | B).x;
}

void setServerConfiguration() {
  setReactConfiguration(_reactDom, _registerComponent, null, _renderComponentToString, _renderToStaticMarkup, null, null);
}
