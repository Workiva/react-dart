## [5.6.0](https://github.com/cleandart/react-dart/compare/5.5.1...5.6.0)

- [#275] Add `forwardRef2` / `memo2` to fix _"jsification"_ of Dart props
    - Deprecates `forwardRef` / `memo`
- [#274] (Security update) Bump serialize-javascript JS dependency to version `3.1.0`

## [5.5.1](https://github.com/cleandart/react-dart/compare/5.5.0...5.5.1)

- [#258] Exclude `propTypes` from Dart2js output.
    - Deprecate `registerComponent`.
        - _Accidentally overlooked when `Component` was deprecated_
- [#276] Allow null ref value in `useImperativeHandle` hook

## [5.5.0](https://github.com/cleandart/react-dart/compare/5.4.0...5.5.0)

__New Features__

- 🎉 🎉 🎉 __Support for function components, memo and hooks!!!__ 🎉 🎉 🎉

    Sooooo much work from so many amazing people made this possible, but to summarize: 
    
    - [#221] Add support for function components
    - [#252] Add support for `memo` higher order component
    - Hooks, hooks, and more hooks!
        - [#223] useState
        - [#233] useCallback
        - [#237] useContext
        - [#227] useEffect
        - [#248] useLayoutEffect
        - [#232] useReducer
        - [#245] useRef
        - [#250] useMemo
        - [#247] useImperativeHandle
        - [#246] useDebugValue

    <p><br>It works like this...</p>
    
    Define the component:
    ```dart
    import 'package:react/react.dart' as react;
    
    final SomeWidget = react.registerFunctionComponent(_SomeWidget, displayName: 'SomeWidget');
    
    _SomeWidget(Map props) {
      // You can use hooks in here, too!
      
      return react.div({}, [
        // Some children...
      ]);
    }
    ```
    
    Render the component _(exact same consumer API as a class-based component)_:
    ```dart
    import 'package:react/react_dom.dart' as react_dom;
    import 'some_widget.dart'; // Where your component is defined
    
    main() {
      final renderedWidget = SomeWidget({
        // put some props here
      }, [
        // put some children here!
      ]);
    
      react_dom.render(renderedWidget, querySelector('#idOfSomeNodeInTheDom'));
    }
    ```
    
    > Check out all the [function component and hooks examples](https://github.com/cleandart/react-dart/blob/c9a1211d5d77a9e354b864e99ef8f52b60eeff85/example/test/function_component_test.dart) for more information!
        
__Fixes / Updates__
- [#253] Deprecate `setClientConfiguration`.
    - It is no longer necessary - and can be removed from your implementations
- [#273] Make `JsBackedMap.values` compatible with MSIE 11

## [5.4.0](https://github.com/cleandart/react-dart/compare/5.3.0...5.4.0)

__New Features__
- [#244] Add support for [HTML Composition events](https://developer.mozilla.org/en-US/docs/Web/API/CompositionEvent)
- [#263] Add support for [`SyntheticEvent.persist()`](https://reactjs.org/docs/events.html#event-pooling) 

__Fixes / Updates__
- [#261] Stop errors thrown within the call stack of `Component.render()` from being swallowed
- [#256] Documentation updates _(thanks @barriehadfield !!!)_

__JS Dependency Updates__
- [#255] Bump acorn from `6.4.0` to `6.4.1`
- [#260] Bump lodash from `4.17.15` to `4.17.19`


## [5.3.0](https://github.com/cleandart/react-dart/compare/5.2.1...5.3.0)

- Unpin the react-redux JS dependency to allow versions `7.1.1` and higher.
- Run over_react tests as part of the CI process to prevent another situation where changing JS dependencies
  regressed tightly coupled libs like `over_react_redux` (like the one that required the 5.2.1 hotfix).
- [#242] Implement StrictMode Component

## [5.2.1](https://github.com/cleandart/react-dart/compare/5.2.0...5.2.1)

- Temporarily pin react-redux dependency to version `7.1.0` to prevent widespread test failures as a result of
  [`Provider` being converted into a function component with hooks](https://github.com/reduxjs/react-redux/pull/1377).

## [5.2.0](https://github.com/cleandart/react-dart/compare/5.1.1...5.2.0)

- [#190] Fix null value handling in `setStateWithUpdater`
- [#235] Fix null value handling in `getDerivedStateFromError` interop
- [#238] Fix js package security vulnerability
- [#236] Expose `componentZone` to allow overriding the zone in which Component2 lifecycle methods are run, for testing

## [5.1.1](https://github.com/cleandart/react-dart/compare/5.1.0...5.1.1)

- Improve the documentation for deprecated `Component2` lifecycle methods.

## [5.1.0](https://github.com/cleandart/react-dart/compare/5.0.1...5.1.0)

__Full ReactJS 16.x Component Lifecycle Support__

- The new `Component2` class replaces the now deprecated `Component` class.
  - Faster
  - Improved dev experience
  - Easier to maintain
  - Easier integration with JS libs
    - `ReactJsComponentFactoryProxy` makes it easy to use JS components with Dart!
      - [Check out this example of MaterialUI components!](https://github.com/cleandart/react-dart/blob/5.1.0-wip/example/js_components/js_components.dart#L115-L145)
  - Supports new lifecycle methods, allowing us to use Concurrent Mode in the future
    - <s>`componentWillMount`</s> => `componentDidMount`
    - <s>`componentWillReceiveProps`</s> => `getDerivedStateFromProps` _(new)_
    - <s>`componentWillUpdate`</s> => `getSnapshotBeforeUpdate` _(new)_
    - `componentDidCatch` / `getDerivedStateFromError` _(new)_
      - Adds support for [error boundaries](https://reactjs.org/docs/error-boundaries.html).

__[Portals](https://reactjs.org/docs/portals.html)__

- _"Portals provide a first-class way to render children into a DOM node that exists outside the DOM hierarchy of the parent component."_

__Improved, stable [Context](https://reactjs.org/docs/context.html) API__

- _"Context provides a way to pass data through the component tree without having to pass props down manually at every level. … Context is primarily used when some data needs to be accessible by many components at different nesting levels. Apply it sparingly because it makes component reuse more difficult."_

__[Fragments](https://reactjs.org/docs/fragments.html)__

- _"A common pattern in React is for a component to return multiple elements. Fragments let you group a list of children without adding extra nodes to the DOM."_
- Component.render can now return Fragments (multiple children) or other values like strings and lists instead of just a single ReactElement

__New and improved ref API: [React.createRef](https://reactjs.org/docs/refs-and-the-dom.html#creating-refs)__

__[React Redux](https://react-redux.js.org/) is now included in the JS bundles and exposed via `window.ReactRedux`.__

> [Full list of 5.1.0 Changes](https://github.com/cleandart/react-dart/milestone/1?closed=1)

## [5.0.1](https://github.com/cleandart/react-dart/compare/5.0.0...5.0.1)
Pull in 4.9.2 changes that were accidentally reverted as part of 5.0.0.
> - [#220] Fix bug where reading `dataTransfer` sometimes threw during synthetic event conversion

## [5.0.0](https://github.com/cleandart/react-dart/compare/4.9.1...5.0.0)

  __ReactJS 16.x Support__

  - The underlying `.js` files provided by this package are now ReactJS version 16.
  - Support for the new / updated lifecycle methods from ReactJS 16 [will be released in version `5.1.0`](https://github.com/cleandart/react-dart/milestone/1).

> [Full list of 5.0.0 Changes](https://github.com/cleandart/react-dart/milestone/2?closed=1)

> __[Full List of Breaking Changes](https://github.com/cleandart/react-dart/pull/224)__

## [4.9.2](https://github.com/cleandart/react-dart/compare/4.9.1...4.9.2)
- [#220] Fix bug where reading `dataTransfer` sometimes threw during synthetic event conversion

## [4.9.1](https://github.com/cleandart/react-dart/compare/4.9.0...4.9.1)
- [#205] Fix `context` setter typing to match getter and not fail `implicit_casts: false`

## [4.9.0](https://github.com/cleandart/react-dart/compare/4.8.1...4.9.0)
- [#202] Add bindings for transition / animation events
- [#198] Updates in preparation for 5.0.0 release

## [4.8.1](https://github.com/cleandart/react-dart/compare/4.8.0...4.8.1)
- [#197] Fix Dart component callback refs with typed arguments not working in Dart 2
    dynamic ref argument (worked):
    ```dart
    Foo({'ref': (ref) => _fooRef = ref})
    ```
    non-dynamic ref argument (did not work):
    ```dart
    Foo({'ref': (FooComponent ref) => _fooRef = ref})
    ```

## [4.8.0](https://github.com/cleandart/react-dart/compare/4.7.1...4.8.0)

- [#181]: Remove unnecessary zoning on event handlers that interferes with testing
    - Handlers triggered by real events will now always be called in the root zone.

      In most cases, handlers were already running in the root zone, so this should not affect behavior. See [#179] for more details.
    - When testing, you previous had to bind event handlers or callbacks triggered by event handlers to zones when using `expect` or `expectAsync`.
        ```dart
        var renderedInstance = renderIntoDocument(
          Button({}, {
            'onButtonPress': Zone.current.bindUnaryCallback(expectAsync((e) {
              // ...
            }, reason: 'onButtonPress not called')),
            'onClick': Zone.current.bindUnaryCallback((e) {
              expect(e.defaultPrevented, isTrue);
            }),
          }),
        );

        // ...
        Simulate.click(buttonNode);
        ```
        Now, handlers will be called in the zone they're triggered from, which makes testing events easier and more predictable:
        ```dart
        var renderedInstance = renderIntoDocument(
          Button({}, {
            'onButtonPress': expectAsync((e) {
              // ...
            }, reason: 'onButtonPress not called'),
            'onClick': (e) {
              expect(e.defaultPrevented, isTrue);
            },
          }),
        );

        // ...
        Simulate.click(buttonNode);
        ```


## [4.7.1](https://github.com/cleandart/react-dart/compare/4.7.0...4.7.1)

- [#182]: Deprecate `emptyJsMap`:
    - Use `newObject()` from `dart:js_util` instead


## [4.7.0](https://github.com/cleandart/react-dart/compare/4.6.2...4.7.0)

- [#162]: Add `jsifyAndAllowInterop`, deprecate some obsolete JS utils:
    - Deprecate `jsify`, `setProperty`, and `getProperty`; use versions from `dart:js_util` instead
    - Deprecate `EmptyObject`; use `newObject` from `dart:js_util` instead
- [#170]: Reformat with line length of 120 for better readability


## [4.6.2](https://github.com/cleandart/react-dart/compare/4.6.1...4.6.2)

- [#162]: **Important Deprecations**
    > These deprecations are being put in place to prepare consumers for the upcoming `5.0.0` release which will include support for React JS version 16.x
    - `react_server.dart` and Dart VM server-side rendering
        - Server-side rendering via `react_dom_server.dart`, though untested, is still in place
    - Legacy `context` APIs
    - `isMounted`
    - `react_test_utils.SimulateNative`
    - String `Component.ref`s
    - `Component.replaceState`s
    - `Component.bind`
    - `Component.transferComponentState`

- [#155]: Clean the lint trap.


## [4.6.1](https://github.com/cleandart/react-dart/compare/4.6.0...4.6.1)

- [#159]: Update the type for [unconverted js `style` prop map][#153] to be `Map<String, dynamic>`.


## [4.6.0](https://github.com/cleandart/react-dart/compare/4.5.0...4.6.0)

- [#152]: Format all files using `dartfmt`.
- [#153]: New `unconvertJsProps` utility function.


## [4.5.0](https://github.com/cleandart/react-dart/compare/4.4.2...4.5.0)

- **Improvement:** Dart 2 compatible!







[#152]: https://github.com/cleandart/react-dart/pull/152
[#153]: https://github.com/cleandart/react-dart/pull/153
[#154]: https://github.com/cleandart/react-dart/pull/154
[#155]: https://github.com/cleandart/react-dart/pull/155
[#156]: https://github.com/cleandart/react-dart/pull/156
[#157]: https://github.com/cleandart/react-dart/pull/157
[#158]: https://github.com/cleandart/react-dart/pull/158
[#159]: https://github.com/cleandart/react-dart/pull/159
[#160]: https://github.com/cleandart/react-dart/pull/160
[#161]: https://github.com/cleandart/react-dart/pull/161
[#162]: https://github.com/cleandart/react-dart/pull/162
[#163]: https://github.com/cleandart/react-dart/pull/163
[#164]: https://github.com/cleandart/react-dart/pull/164
[#165]: https://github.com/cleandart/react-dart/pull/165
[#166]: https://github.com/cleandart/react-dart/pull/166
[#167]: https://github.com/cleandart/react-dart/pull/167
[#168]: https://github.com/cleandart/react-dart/pull/168
[#169]: https://github.com/cleandart/react-dart/pull/169
[#170]: https://github.com/cleandart/react-dart/pull/170
[#171]: https://github.com/cleandart/react-dart/pull/171
[#172]: https://github.com/cleandart/react-dart/pull/172
[#173]: https://github.com/cleandart/react-dart/pull/173
[#174]: https://github.com/cleandart/react-dart/pull/174
[#175]: https://github.com/cleandart/react-dart/pull/175
[#176]: https://github.com/cleandart/react-dart/pull/176
[#177]: https://github.com/cleandart/react-dart/pull/177
[#178]: https://github.com/cleandart/react-dart/pull/178
[#179]: https://github.com/cleandart/react-dart/pull/179
[#180]: https://github.com/cleandart/react-dart/pull/180
[#181]: https://github.com/cleandart/react-dart/pull/181
[#182]: https://github.com/cleandart/react-dart/pull/182
[#183]: https://github.com/cleandart/react-dart/pull/183
[#184]: https://github.com/cleandart/react-dart/pull/184
[#185]: https://github.com/cleandart/react-dart/pull/185
[#186]: https://github.com/cleandart/react-dart/pull/186
[#187]: https://github.com/cleandart/react-dart/pull/187
[#188]: https://github.com/cleandart/react-dart/pull/188
[#189]: https://github.com/cleandart/react-dart/pull/189
[#190]: https://github.com/cleandart/react-dart/pull/190
[#191]: https://github.com/cleandart/react-dart/pull/191
[#192]: https://github.com/cleandart/react-dart/pull/192
[#193]: https://github.com/cleandart/react-dart/pull/193
[#194]: https://github.com/cleandart/react-dart/pull/194
[#195]: https://github.com/cleandart/react-dart/pull/195
[#196]: https://github.com/cleandart/react-dart/pull/196
[#197]: https://github.com/cleandart/react-dart/pull/197
[#198]: https://github.com/cleandart/react-dart/pull/198
[#199]: https://github.com/cleandart/react-dart/pull/199
[#200]: https://github.com/cleandart/react-dart/pull/200
[#201]: https://github.com/cleandart/react-dart/pull/201
[#202]: https://github.com/cleandart/react-dart/pull/202
[#203]: https://github.com/cleandart/react-dart/pull/203
[#204]: https://github.com/cleandart/react-dart/pull/204
[#205]: https://github.com/cleandart/react-dart/pull/205
[#206]: https://github.com/cleandart/react-dart/pull/206
[#207]: https://github.com/cleandart/react-dart/pull/207
[#208]: https://github.com/cleandart/react-dart/pull/208
[#209]: https://github.com/cleandart/react-dart/pull/209
[#210]: https://github.com/cleandart/react-dart/pull/210
[#211]: https://github.com/cleandart/react-dart/pull/211
[#212]: https://github.com/cleandart/react-dart/pull/212
[#213]: https://github.com/cleandart/react-dart/pull/213
[#214]: https://github.com/cleandart/react-dart/pull/214
[#215]: https://github.com/cleandart/react-dart/pull/215
[#216]: https://github.com/cleandart/react-dart/pull/216
[#217]: https://github.com/cleandart/react-dart/pull/217
[#218]: https://github.com/cleandart/react-dart/pull/218
[#219]: https://github.com/cleandart/react-dart/pull/219
[#220]: https://github.com/cleandart/react-dart/pull/220
[#221]: https://github.com/cleandart/react-dart/pull/221
[#222]: https://github.com/cleandart/react-dart/pull/222
[#223]: https://github.com/cleandart/react-dart/pull/223
[#224]: https://github.com/cleandart/react-dart/pull/224
[#225]: https://github.com/cleandart/react-dart/pull/225
[#226]: https://github.com/cleandart/react-dart/pull/226
[#227]: https://github.com/cleandart/react-dart/pull/227
[#228]: https://github.com/cleandart/react-dart/pull/228
[#229]: https://github.com/cleandart/react-dart/pull/229
[#230]: https://github.com/cleandart/react-dart/pull/230
[#231]: https://github.com/cleandart/react-dart/pull/231
[#232]: https://github.com/cleandart/react-dart/pull/232
[#233]: https://github.com/cleandart/react-dart/pull/233
[#234]: https://github.com/cleandart/react-dart/pull/234
[#235]: https://github.com/cleandart/react-dart/pull/235
[#236]: https://github.com/cleandart/react-dart/pull/236
[#237]: https://github.com/cleandart/react-dart/pull/237
[#238]: https://github.com/cleandart/react-dart/pull/238
[#239]: https://github.com/cleandart/react-dart/pull/239
[#240]: https://github.com/cleandart/react-dart/pull/240
[#241]: https://github.com/cleandart/react-dart/pull/241
[#242]: https://github.com/cleandart/react-dart/pull/242
[#243]: https://github.com/cleandart/react-dart/pull/243
[#244]: https://github.com/cleandart/react-dart/pull/244
[#245]: https://github.com/cleandart/react-dart/pull/245
[#246]: https://github.com/cleandart/react-dart/pull/246
[#247]: https://github.com/cleandart/react-dart/pull/247
[#248]: https://github.com/cleandart/react-dart/pull/248
[#249]: https://github.com/cleandart/react-dart/pull/249
[#250]: https://github.com/cleandart/react-dart/pull/250
[#251]: https://github.com/cleandart/react-dart/pull/251
[#252]: https://github.com/cleandart/react-dart/pull/252
[#253]: https://github.com/cleandart/react-dart/pull/253
[#254]: https://github.com/cleandart/react-dart/pull/254
[#255]: https://github.com/cleandart/react-dart/pull/255
[#256]: https://github.com/cleandart/react-dart/pull/256
[#257]: https://github.com/cleandart/react-dart/pull/257
[#258]: https://github.com/cleandart/react-dart/pull/258
[#259]: https://github.com/cleandart/react-dart/pull/259
[#260]: https://github.com/cleandart/react-dart/pull/260
[#261]: https://github.com/cleandart/react-dart/pull/261
[#262]: https://github.com/cleandart/react-dart/pull/262
[#263]: https://github.com/cleandart/react-dart/pull/263
[#264]: https://github.com/cleandart/react-dart/pull/264
[#265]: https://github.com/cleandart/react-dart/pull/265
[#266]: https://github.com/cleandart/react-dart/pull/266
[#267]: https://github.com/cleandart/react-dart/pull/267
[#268]: https://github.com/cleandart/react-dart/pull/268
[#269]: https://github.com/cleandart/react-dart/pull/269
[#270]: https://github.com/cleandart/react-dart/pull/270
[#271]: https://github.com/cleandart/react-dart/pull/271
[#272]: https://github.com/cleandart/react-dart/pull/272
[#273]: https://github.com/cleandart/react-dart/pull/273
[#274]: https://github.com/cleandart/react-dart/pull/274
[#275]: https://github.com/cleandart/react-dart/pull/275
[#276]: https://github.com/cleandart/react-dart/pull/276
[#277]: https://github.com/cleandart/react-dart/pull/277
[#278]: https://github.com/cleandart/react-dart/pull/278
[#279]: https://github.com/cleandart/react-dart/pull/279
[#280]: https://github.com/cleandart/react-dart/pull/280
[#281]: https://github.com/cleandart/react-dart/pull/281
[#282]: https://github.com/cleandart/react-dart/pull/282
[#283]: https://github.com/cleandart/react-dart/pull/283
[#284]: https://github.com/cleandart/react-dart/pull/284
[#285]: https://github.com/cleandart/react-dart/pull/285
[#286]: https://github.com/cleandart/react-dart/pull/286
[#287]: https://github.com/cleandart/react-dart/pull/287
[#288]: https://github.com/cleandart/react-dart/pull/288
[#289]: https://github.com/cleandart/react-dart/pull/289
[#290]: https://github.com/cleandart/react-dart/pull/290
[#291]: https://github.com/cleandart/react-dart/pull/291
[#292]: https://github.com/cleandart/react-dart/pull/292
[#293]: https://github.com/cleandart/react-dart/pull/293
[#294]: https://github.com/cleandart/react-dart/pull/294
[#295]: https://github.com/cleandart/react-dart/pull/295
[#296]: https://github.com/cleandart/react-dart/pull/296
[#297]: https://github.com/cleandart/react-dart/pull/297
[#298]: https://github.com/cleandart/react-dart/pull/298
[#299]: https://github.com/cleandart/react-dart/pull/299
[#300]: https://github.com/cleandart/react-dart/pull/300
[#301]: https://github.com/cleandart/react-dart/pull/301
[#302]: https://github.com/cleandart/react-dart/pull/302
[#303]: https://github.com/cleandart/react-dart/pull/303
[#304]: https://github.com/cleandart/react-dart/pull/304
[#305]: https://github.com/cleandart/react-dart/pull/305
[#306]: https://github.com/cleandart/react-dart/pull/306
[#307]: https://github.com/cleandart/react-dart/pull/307
[#308]: https://github.com/cleandart/react-dart/pull/308
[#309]: https://github.com/cleandart/react-dart/pull/309
[#310]: https://github.com/cleandart/react-dart/pull/310
[#311]: https://github.com/cleandart/react-dart/pull/311
[#312]: https://github.com/cleandart/react-dart/pull/312
[#313]: https://github.com/cleandart/react-dart/pull/313
[#314]: https://github.com/cleandart/react-dart/pull/314
[#315]: https://github.com/cleandart/react-dart/pull/315
[#316]: https://github.com/cleandart/react-dart/pull/316
[#317]: https://github.com/cleandart/react-dart/pull/317
[#318]: https://github.com/cleandart/react-dart/pull/318
[#319]: https://github.com/cleandart/react-dart/pull/319
[#320]: https://github.com/cleandart/react-dart/pull/320
[#321]: https://github.com/cleandart/react-dart/pull/321
[#322]: https://github.com/cleandart/react-dart/pull/322
[#323]: https://github.com/cleandart/react-dart/pull/323
[#324]: https://github.com/cleandart/react-dart/pull/324
[#325]: https://github.com/cleandart/react-dart/pull/325
[#326]: https://github.com/cleandart/react-dart/pull/326
[#327]: https://github.com/cleandart/react-dart/pull/327
[#328]: https://github.com/cleandart/react-dart/pull/328
[#329]: https://github.com/cleandart/react-dart/pull/329
[#330]: https://github.com/cleandart/react-dart/pull/330
[#331]: https://github.com/cleandart/react-dart/pull/331
[#332]: https://github.com/cleandart/react-dart/pull/332
[#333]: https://github.com/cleandart/react-dart/pull/333
[#334]: https://github.com/cleandart/react-dart/pull/334
[#335]: https://github.com/cleandart/react-dart/pull/335
[#336]: https://github.com/cleandart/react-dart/pull/336
[#337]: https://github.com/cleandart/react-dart/pull/337
[#338]: https://github.com/cleandart/react-dart/pull/338
[#339]: https://github.com/cleandart/react-dart/pull/339
[#340]: https://github.com/cleandart/react-dart/pull/340
[#341]: https://github.com/cleandart/react-dart/pull/341
[#342]: https://github.com/cleandart/react-dart/pull/342
[#343]: https://github.com/cleandart/react-dart/pull/343
[#344]: https://github.com/cleandart/react-dart/pull/344
[#345]: https://github.com/cleandart/react-dart/pull/345
[#346]: https://github.com/cleandart/react-dart/pull/346
[#347]: https://github.com/cleandart/react-dart/pull/347
[#348]: https://github.com/cleandart/react-dart/pull/348
[#349]: https://github.com/cleandart/react-dart/pull/349
[#350]: https://github.com/cleandart/react-dart/pull/350
[#351]: https://github.com/cleandart/react-dart/pull/351
[#352]: https://github.com/cleandart/react-dart/pull/352
[#353]: https://github.com/cleandart/react-dart/pull/353
[#354]: https://github.com/cleandart/react-dart/pull/354
[#355]: https://github.com/cleandart/react-dart/pull/355
[#356]: https://github.com/cleandart/react-dart/pull/356
[#357]: https://github.com/cleandart/react-dart/pull/357
[#358]: https://github.com/cleandart/react-dart/pull/358
[#359]: https://github.com/cleandart/react-dart/pull/359
[#360]: https://github.com/cleandart/react-dart/pull/360
[#361]: https://github.com/cleandart/react-dart/pull/361
[#362]: https://github.com/cleandart/react-dart/pull/362
[#363]: https://github.com/cleandart/react-dart/pull/363
[#364]: https://github.com/cleandart/react-dart/pull/364
[#365]: https://github.com/cleandart/react-dart/pull/365
[#366]: https://github.com/cleandart/react-dart/pull/366
[#367]: https://github.com/cleandart/react-dart/pull/367
[#368]: https://github.com/cleandart/react-dart/pull/368
[#369]: https://github.com/cleandart/react-dart/pull/369
[#370]: https://github.com/cleandart/react-dart/pull/370
[#371]: https://github.com/cleandart/react-dart/pull/371
[#372]: https://github.com/cleandart/react-dart/pull/372
[#373]: https://github.com/cleandart/react-dart/pull/373
[#374]: https://github.com/cleandart/react-dart/pull/374
[#375]: https://github.com/cleandart/react-dart/pull/375
[#376]: https://github.com/cleandart/react-dart/pull/376
[#377]: https://github.com/cleandart/react-dart/pull/377
[#378]: https://github.com/cleandart/react-dart/pull/378
[#379]: https://github.com/cleandart/react-dart/pull/379
[#380]: https://github.com/cleandart/react-dart/pull/380
[#381]: https://github.com/cleandart/react-dart/pull/381
[#382]: https://github.com/cleandart/react-dart/pull/382
[#383]: https://github.com/cleandart/react-dart/pull/383
[#384]: https://github.com/cleandart/react-dart/pull/384
[#385]: https://github.com/cleandart/react-dart/pull/385
[#386]: https://github.com/cleandart/react-dart/pull/386
[#387]: https://github.com/cleandart/react-dart/pull/387
[#388]: https://github.com/cleandart/react-dart/pull/388
[#389]: https://github.com/cleandart/react-dart/pull/389
[#390]: https://github.com/cleandart/react-dart/pull/390
[#391]: https://github.com/cleandart/react-dart/pull/391
[#392]: https://github.com/cleandart/react-dart/pull/392
[#393]: https://github.com/cleandart/react-dart/pull/393
[#394]: https://github.com/cleandart/react-dart/pull/394
[#395]: https://github.com/cleandart/react-dart/pull/395
[#396]: https://github.com/cleandart/react-dart/pull/396
[#397]: https://github.com/cleandart/react-dart/pull/397
[#398]: https://github.com/cleandart/react-dart/pull/398
[#399]: https://github.com/cleandart/react-dart/pull/399
[#400]: https://github.com/cleandart/react-dart/pull/400
[#401]: https://github.com/cleandart/react-dart/pull/401
[#402]: https://github.com/cleandart/react-dart/pull/402
[#403]: https://github.com/cleandart/react-dart/pull/403
[#404]: https://github.com/cleandart/react-dart/pull/404
[#405]: https://github.com/cleandart/react-dart/pull/405
[#406]: https://github.com/cleandart/react-dart/pull/406
[#407]: https://github.com/cleandart/react-dart/pull/407
[#408]: https://github.com/cleandart/react-dart/pull/408
[#409]: https://github.com/cleandart/react-dart/pull/409
[#410]: https://github.com/cleandart/react-dart/pull/410
[#411]: https://github.com/cleandart/react-dart/pull/411
[#412]: https://github.com/cleandart/react-dart/pull/412
[#413]: https://github.com/cleandart/react-dart/pull/413
[#414]: https://github.com/cleandart/react-dart/pull/414
[#415]: https://github.com/cleandart/react-dart/pull/415
[#416]: https://github.com/cleandart/react-dart/pull/416
[#417]: https://github.com/cleandart/react-dart/pull/417
[#418]: https://github.com/cleandart/react-dart/pull/418
[#419]: https://github.com/cleandart/react-dart/pull/419
[#420]: https://github.com/cleandart/react-dart/pull/420
[#421]: https://github.com/cleandart/react-dart/pull/421
[#422]: https://github.com/cleandart/react-dart/pull/422
[#423]: https://github.com/cleandart/react-dart/pull/423
[#424]: https://github.com/cleandart/react-dart/pull/424
[#425]: https://github.com/cleandart/react-dart/pull/425
[#426]: https://github.com/cleandart/react-dart/pull/426
[#427]: https://github.com/cleandart/react-dart/pull/427
[#428]: https://github.com/cleandart/react-dart/pull/428
[#429]: https://github.com/cleandart/react-dart/pull/429
[#430]: https://github.com/cleandart/react-dart/pull/430
[#431]: https://github.com/cleandart/react-dart/pull/431
[#432]: https://github.com/cleandart/react-dart/pull/432
[#433]: https://github.com/cleandart/react-dart/pull/433
[#434]: https://github.com/cleandart/react-dart/pull/434
[#435]: https://github.com/cleandart/react-dart/pull/435
[#436]: https://github.com/cleandart/react-dart/pull/436
[#437]: https://github.com/cleandart/react-dart/pull/437
[#438]: https://github.com/cleandart/react-dart/pull/438
[#439]: https://github.com/cleandart/react-dart/pull/439
[#440]: https://github.com/cleandart/react-dart/pull/440
[#441]: https://github.com/cleandart/react-dart/pull/441
[#442]: https://github.com/cleandart/react-dart/pull/442
[#443]: https://github.com/cleandart/react-dart/pull/443
[#444]: https://github.com/cleandart/react-dart/pull/444
[#445]: https://github.com/cleandart/react-dart/pull/445
[#446]: https://github.com/cleandart/react-dart/pull/446
[#447]: https://github.com/cleandart/react-dart/pull/447
[#448]: https://github.com/cleandart/react-dart/pull/448
[#449]: https://github.com/cleandart/react-dart/pull/449
[#450]: https://github.com/cleandart/react-dart/pull/450
[#451]: https://github.com/cleandart/react-dart/pull/451
[#452]: https://github.com/cleandart/react-dart/pull/452
[#453]: https://github.com/cleandart/react-dart/pull/453
[#454]: https://github.com/cleandart/react-dart/pull/454
[#455]: https://github.com/cleandart/react-dart/pull/455
[#456]: https://github.com/cleandart/react-dart/pull/456
[#457]: https://github.com/cleandart/react-dart/pull/457
[#458]: https://github.com/cleandart/react-dart/pull/458
[#459]: https://github.com/cleandart/react-dart/pull/459
[#460]: https://github.com/cleandart/react-dart/pull/460
[#461]: https://github.com/cleandart/react-dart/pull/461
[#462]: https://github.com/cleandart/react-dart/pull/462
[#463]: https://github.com/cleandart/react-dart/pull/463
[#464]: https://github.com/cleandart/react-dart/pull/464
[#465]: https://github.com/cleandart/react-dart/pull/465
[#466]: https://github.com/cleandart/react-dart/pull/466
[#467]: https://github.com/cleandart/react-dart/pull/467
[#468]: https://github.com/cleandart/react-dart/pull/468
[#469]: https://github.com/cleandart/react-dart/pull/469
[#470]: https://github.com/cleandart/react-dart/pull/470
[#471]: https://github.com/cleandart/react-dart/pull/471
[#472]: https://github.com/cleandart/react-dart/pull/472
[#473]: https://github.com/cleandart/react-dart/pull/473
[#474]: https://github.com/cleandart/react-dart/pull/474
[#475]: https://github.com/cleandart/react-dart/pull/475
[#476]: https://github.com/cleandart/react-dart/pull/476
[#477]: https://github.com/cleandart/react-dart/pull/477
[#478]: https://github.com/cleandart/react-dart/pull/478
[#479]: https://github.com/cleandart/react-dart/pull/479
[#480]: https://github.com/cleandart/react-dart/pull/480
[#481]: https://github.com/cleandart/react-dart/pull/481
[#482]: https://github.com/cleandart/react-dart/pull/482
[#483]: https://github.com/cleandart/react-dart/pull/483
[#484]: https://github.com/cleandart/react-dart/pull/484
[#485]: https://github.com/cleandart/react-dart/pull/485
[#486]: https://github.com/cleandart/react-dart/pull/486
[#487]: https://github.com/cleandart/react-dart/pull/487
[#488]: https://github.com/cleandart/react-dart/pull/488
[#489]: https://github.com/cleandart/react-dart/pull/489
[#490]: https://github.com/cleandart/react-dart/pull/490
[#491]: https://github.com/cleandart/react-dart/pull/491
[#492]: https://github.com/cleandart/react-dart/pull/492
[#493]: https://github.com/cleandart/react-dart/pull/493
[#494]: https://github.com/cleandart/react-dart/pull/494
[#495]: https://github.com/cleandart/react-dart/pull/495
[#496]: https://github.com/cleandart/react-dart/pull/496
[#497]: https://github.com/cleandart/react-dart/pull/497
[#498]: https://github.com/cleandart/react-dart/pull/498
[#499]: https://github.com/cleandart/react-dart/pull/499
[#500]: https://github.com/cleandart/react-dart/pull/500
[#501]: https://github.com/cleandart/react-dart/pull/501
[#502]: https://github.com/cleandart/react-dart/pull/502
[#503]: https://github.com/cleandart/react-dart/pull/503
[#504]: https://github.com/cleandart/react-dart/pull/504
[#505]: https://github.com/cleandart/react-dart/pull/505
[#506]: https://github.com/cleandart/react-dart/pull/506
[#507]: https://github.com/cleandart/react-dart/pull/507
[#508]: https://github.com/cleandart/react-dart/pull/508
[#509]: https://github.com/cleandart/react-dart/pull/509
[#510]: https://github.com/cleandart/react-dart/pull/510
[#511]: https://github.com/cleandart/react-dart/pull/511
[#512]: https://github.com/cleandart/react-dart/pull/512
[#513]: https://github.com/cleandart/react-dart/pull/513
[#514]: https://github.com/cleandart/react-dart/pull/514
[#515]: https://github.com/cleandart/react-dart/pull/515
[#516]: https://github.com/cleandart/react-dart/pull/516
[#517]: https://github.com/cleandart/react-dart/pull/517
[#518]: https://github.com/cleandart/react-dart/pull/518
[#519]: https://github.com/cleandart/react-dart/pull/519
[#520]: https://github.com/cleandart/react-dart/pull/520
[#521]: https://github.com/cleandart/react-dart/pull/521
[#522]: https://github.com/cleandart/react-dart/pull/522
[#523]: https://github.com/cleandart/react-dart/pull/523
[#524]: https://github.com/cleandart/react-dart/pull/524
[#525]: https://github.com/cleandart/react-dart/pull/525
[#526]: https://github.com/cleandart/react-dart/pull/526
[#527]: https://github.com/cleandart/react-dart/pull/527
[#528]: https://github.com/cleandart/react-dart/pull/528
[#529]: https://github.com/cleandart/react-dart/pull/529
[#530]: https://github.com/cleandart/react-dart/pull/530
[#531]: https://github.com/cleandart/react-dart/pull/531
[#532]: https://github.com/cleandart/react-dart/pull/532
[#533]: https://github.com/cleandart/react-dart/pull/533
[#534]: https://github.com/cleandart/react-dart/pull/534
[#535]: https://github.com/cleandart/react-dart/pull/535
[#536]: https://github.com/cleandart/react-dart/pull/536
[#537]: https://github.com/cleandart/react-dart/pull/537
[#538]: https://github.com/cleandart/react-dart/pull/538
[#539]: https://github.com/cleandart/react-dart/pull/539
[#540]: https://github.com/cleandart/react-dart/pull/540
[#541]: https://github.com/cleandart/react-dart/pull/541
[#542]: https://github.com/cleandart/react-dart/pull/542
[#543]: https://github.com/cleandart/react-dart/pull/543
[#544]: https://github.com/cleandart/react-dart/pull/544
[#545]: https://github.com/cleandart/react-dart/pull/545
[#546]: https://github.com/cleandart/react-dart/pull/546
[#547]: https://github.com/cleandart/react-dart/pull/547
[#548]: https://github.com/cleandart/react-dart/pull/548
[#549]: https://github.com/cleandart/react-dart/pull/549
[#550]: https://github.com/cleandart/react-dart/pull/550
[#551]: https://github.com/cleandart/react-dart/pull/551
[#552]: https://github.com/cleandart/react-dart/pull/552
[#553]: https://github.com/cleandart/react-dart/pull/553
[#554]: https://github.com/cleandart/react-dart/pull/554
[#555]: https://github.com/cleandart/react-dart/pull/555
[#556]: https://github.com/cleandart/react-dart/pull/556
[#557]: https://github.com/cleandart/react-dart/pull/557
[#558]: https://github.com/cleandart/react-dart/pull/558
[#559]: https://github.com/cleandart/react-dart/pull/559
[#560]: https://github.com/cleandart/react-dart/pull/560
[#561]: https://github.com/cleandart/react-dart/pull/561
[#562]: https://github.com/cleandart/react-dart/pull/562
[#563]: https://github.com/cleandart/react-dart/pull/563
[#564]: https://github.com/cleandart/react-dart/pull/564
[#565]: https://github.com/cleandart/react-dart/pull/565
[#566]: https://github.com/cleandart/react-dart/pull/566
[#567]: https://github.com/cleandart/react-dart/pull/567
[#568]: https://github.com/cleandart/react-dart/pull/568
[#569]: https://github.com/cleandart/react-dart/pull/569
[#570]: https://github.com/cleandart/react-dart/pull/570
[#571]: https://github.com/cleandart/react-dart/pull/571
[#572]: https://github.com/cleandart/react-dart/pull/572
[#573]: https://github.com/cleandart/react-dart/pull/573
[#574]: https://github.com/cleandart/react-dart/pull/574
[#575]: https://github.com/cleandart/react-dart/pull/575
[#576]: https://github.com/cleandart/react-dart/pull/576
[#577]: https://github.com/cleandart/react-dart/pull/577
[#578]: https://github.com/cleandart/react-dart/pull/578
[#579]: https://github.com/cleandart/react-dart/pull/579
[#580]: https://github.com/cleandart/react-dart/pull/580
[#581]: https://github.com/cleandart/react-dart/pull/581
[#582]: https://github.com/cleandart/react-dart/pull/582
[#583]: https://github.com/cleandart/react-dart/pull/583
[#584]: https://github.com/cleandart/react-dart/pull/584
[#585]: https://github.com/cleandart/react-dart/pull/585
[#586]: https://github.com/cleandart/react-dart/pull/586
[#587]: https://github.com/cleandart/react-dart/pull/587
[#588]: https://github.com/cleandart/react-dart/pull/588
[#589]: https://github.com/cleandart/react-dart/pull/589
[#590]: https://github.com/cleandart/react-dart/pull/590
[#591]: https://github.com/cleandart/react-dart/pull/591
[#592]: https://github.com/cleandart/react-dart/pull/592
[#593]: https://github.com/cleandart/react-dart/pull/593
[#594]: https://github.com/cleandart/react-dart/pull/594
[#595]: https://github.com/cleandart/react-dart/pull/595
[#596]: https://github.com/cleandart/react-dart/pull/596
[#597]: https://github.com/cleandart/react-dart/pull/597
[#598]: https://github.com/cleandart/react-dart/pull/598
[#599]: https://github.com/cleandart/react-dart/pull/599

