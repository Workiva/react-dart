library mfe.js_module_loader;

import 'dart:html';

import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:meta/meta.dart';

class GlobalOrDynamicImportLoader<JsModule> {
  final String globalWindowName;
  final String asyncModuleName;

  ModuleLoadType _selectedLoadType = ModuleLoadType.unspecified;
  JsModule _module;

  GlobalOrDynamicImportLoader({@required this.globalWindowName, @required this.asyncModuleName});

  JsModule get module {
    switch (_selectedLoadType) {
      case ModuleLoadType.unspecified:
        initJsModuleFromWindow();
        if (_module == null) {
          throw StateError('Loading module from window failed.');
        }
        break;
      case ModuleLoadType.window:
        if (_module == null) {
          throw StateError('Loading module from window failed.');
        }
        break;
      case ModuleLoadType.asyncImport:
        if (_module == null) {
          throw StateError('initJsModuleFromAsyncImport is either still running or failed.');
        }
        break;
    }

    return _module;
  }

  // FIXME synchronize this
  Future<void> initJsModuleFromAsyncImport() async {
    switch (_selectedLoadType) {
      case ModuleLoadType.unspecified:
        _selectedLoadType = ModuleLoadType.asyncImport;
        break;
      case ModuleLoadType.asyncImport:
        break;
      case ModuleLoadType.window:
        throw StateError('Already opted into ModuleLoadType.window.');
    }

    if (_module != null) return;

    _module = await esmDynamicImport(asyncModuleName);
    if (_module == null) {
      throw Exception('Null module');
    }
  }

  void initJsModuleFromWindow() {
    switch (_selectedLoadType) {
      case ModuleLoadType.unspecified:
        _selectedLoadType = ModuleLoadType.asyncImport;
        break;
      case ModuleLoadType.window:
        break;
      case ModuleLoadType.asyncImport:
        throw StateError('Already opted into ModuleLoadType.asyncImport.');
    }

    if (_module != null) return;

    _module = getProperty(window, globalWindowName) as JsModule;
    if (_module == null) {
      throw Exception('window.$globalWindowName was null');
    }
  }
}

enum ModuleLoadType {
  unspecified,
  window,
  asyncImport,
}

/// Wrapper for the dynamic import (`import(…)`) JS Function.
///
/// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/import
///
/// We can't interop `import` directly since it's not a function, but a keyword, so
/// we need a wrapper function.
///
/// ```
/// function _esmDynamicImport(moduleName) {
///   return import(moduleName);
/// }
/// ```
@JS()
external _Promise _esmDynamicImport(String moduleName);

@JS('Promise')
class _Promise {}

Future<T> esmDynamicImport<T>(String moduleName) async =>
    await promiseToFuture(_esmDynamicImport(moduleName)) as T;
