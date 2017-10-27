#!/usr/bin/env bash

# Builds JS files by concatenating React and custom JS files,
# and places them in lib/ with the expected names.
#
# To use, update the files in js_src and rerun this script.

set -e

DART_HELPERS_JS="js_src/dart_helpers.js"

rm lib/*.js

cat js_src/react.js             $DART_HELPERS_JS > lib/react.js
echo 'Created lib/react.js'

cat js_src/react.min.js         $DART_HELPERS_JS > lib/react_prod.js
echo 'Created lib/react_prod.js'

cat js_src/react-with-addons.js $DART_HELPERS_JS > lib/react_with_addons.js
echo 'Created lib/react_with_addons.js'

cp js_src/react-dom.js            lib/react_dom.js
echo 'Created lib/react_dom.js'

cp js_src/react-dom.min.js        lib/react_dom_prod.js
echo 'Created lib/react_dom_prod.js'

cp js_src/react-dom-server.js     lib/react_dom_server.js
echo 'Created lib/react_dom_server.js'

cp js_src/react-dom-server.min.js lib/react_dom_server_prod.js
echo 'Created lib/react_dom_server_prod.js'

cat lib/react_prod.js lib/react_dom_prod.js > lib/react_with_react_dom_prod.js
echo 'Created lib/react_with_react_dom_prod.js'
