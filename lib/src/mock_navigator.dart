import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

class _MockMaterialPageRoute extends MaterialPageRoute<void> {
  _MockMaterialPageRoute({required super.builder});

  void hackOverlays() {
    for (var i = 0; i < overlayEntries.length; i++) {
      // Entry can only be inserted when the state is mounted
      final state = _MockOverlayState().._mounted = true;
      final entry = OverlayEntry(builder: (_) => const SizedBox());
      try {
        // We need to call insert since that is the only way to populate the
        // `_overlay` field in the entry. But that method calls a setState,
        // which will fail since we are not in a widget tree.
        //
        // By the time the setState is called, the attribute is already set
        // so we just ignore the error and the hack will do its job.
        state.insert(entry);
      } catch (_) {}
      // Set mounted back to false to make sure the state doesn't get
      // marked as dirty during OverlayEntry.remove().
      state._mounted = false;
      overlayEntries[i] = entry;
    }
  }
}

class _MockOverlayState extends OverlayState {
  late bool _mounted;

  @override
  bool get mounted => _mounted;
}

class _FakeRoute<T> extends Fake implements Route<T> {}

/// {@template mock_navigator_provider}
/// The widget that provides an instance of a [MockNavigator].
/// {@endtemplate}
class MockNavigatorProvider extends Navigator {
  /// {@macro mock_navigator_provider}
  const MockNavigatorProvider({
    required this.navigator,
    required this.child,
    super.key,
  });

  /// The mock navigator used to mock navigation calls.
  final MockNavigator navigator;

  /// The [Widget] to render.
  final Widget child;

  @override
  NavigatorState createState() {
    // The hack that makes it all work.
    // ignore: no_logic_in_create_state
    return _MockNavigatorState(navigator).._child = child;
  }

  @override
  RouteFactory? get onGenerateRoute {
    return (_) {
      final route = _MockMaterialPageRoute(builder: (_) => child);

      navigator._routes.add(route);

      return route;
    };
  }
}

/// {@template mock_navigator}
/// A mock navigator which can be used to stub navigation for testing purposes.
/// {@endtemplate}
class MockNavigator extends Mock
    with _MockNavigatorDiagnosticsMixin
    implements NavigatorState {
  /// {@macro mock_navigator}
  MockNavigator() {
    registerFallbackValue(_FakeRoute<dynamic>());
    registerFallbackValue(_FakeRoute<Object>());
    registerFallbackValue(_FakeRoute<void>());
    registerFallbackValue(_FakeRoute<bool>());
    registerFallbackValue(_FakeRoute<String>());
    registerFallbackValue(_FakeRoute<num>());
  }

  final _routes = <_MockMaterialPageRoute>[];
}

/// A mixin necessary when implementing a [MockNavigator].
mixin _MockNavigatorDiagnosticsMixin on Object {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Internal class that imitates a [NavigatorState] and maps all the real
/// [NavigatorState] methods to the mock methods for use in testing.
///
/// Any public method of [NavigatorState] used for routing should be overridden
/// and remapped to the internal [_navigator] before any `verify` or `when`
/// calls can function.
class _MockNavigatorState extends NavigatorState {
  _MockNavigatorState(this._navigator);

  final MockNavigator _navigator;

  late Widget _child;

  @override
  Widget build(BuildContext context) => _child;

  @override
  void dispose() {
    for (final route in _navigator._routes) {
      route.hackOverlays();
    }

    super.dispose();
  }

  @override
  Future<T?> push<T extends Object?>(Route<T> route) {
    return _navigator.push<T>(route);
  }

  @override
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator.pushNamed<T>(routeName, arguments: arguments);
  }

  @override
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return _navigator.pushNamedAndRemoveUntil<T>(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  @override
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Route<T> newRoute, {
    TO? result,
  }) {
    return _navigator.pushReplacement<T, TO>(newRoute, result: result);
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return _navigator.pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  @override
  void pop<T extends Object?>([T? result]) {
    return _navigator.pop<T>(result);
  }

  @override
  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return _navigator.popAndPushNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  @override
  void popUntil(RoutePredicate predicate) {
    return _navigator.popUntil(predicate);
  }

  @override
  bool canPop() {
    return _navigator.canPop();
  }

  @override
  Future<bool> maybePop<T extends Object?>([T? result]) {
    return _navigator.maybePop<T>(result);
  }

  @override
  Future<T?> pushAndRemoveUntil<T extends Object?>(
    Route<T> newRoute,
    RoutePredicate predicate,
  ) {
    return _navigator.pushAndRemoveUntil<T>(newRoute, predicate);
  }

  @override
  String restorablePopAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return _navigator.restorablePopAndPushNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  @override
  String restorablePush<T extends Object?>(
    RestorableRouteBuilder<T> routeBuilder, {
    Object? arguments,
  }) {
    return _navigator.restorablePush<T>(routeBuilder, arguments: arguments);
  }

  @override
  String restorablePushAndRemoveUntil<T extends Object?>(
    RestorableRouteBuilder<T> newRouteBuilder,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return _navigator.restorablePushAndRemoveUntil<T>(
      newRouteBuilder,
      predicate,
      arguments: arguments,
    );
  }

  @override
  String restorablePushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator.restorablePushNamed<T>(routeName, arguments: arguments);
  }

  @override
  String restorablePushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    return _navigator.restorablePushNamedAndRemoveUntil<T>(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  @override
  String restorablePushReplacement<T extends Object?, TO extends Object?>(
    RestorableRouteBuilder<T> routeBuilder, {
    TO? result,
    Object? arguments,
  }) {
    return _navigator.restorablePushReplacement<T, TO>(
      routeBuilder,
      result: result,
      arguments: arguments,
    );
  }

  @override
  String restorablePushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return _navigator.restorablePushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  @override
  String restorableReplace<T extends Object?>({
    required Route<dynamic> oldRoute,
    required RestorableRouteBuilder<T> newRouteBuilder,
    Object? arguments,
  }) {
    return _navigator.restorableReplace<T>(
      oldRoute: oldRoute,
      newRouteBuilder: newRouteBuilder,
      arguments: arguments,
    );
  }

  @override
  String restorableReplaceRouteBelow<T extends Object?>({
    required Route<dynamic> anchorRoute,
    required RestorableRouteBuilder<T> newRouteBuilder,
    Object? arguments,
  }) {
    return _navigator.restorableReplaceRouteBelow<T>(
      anchorRoute: anchorRoute,
      newRouteBuilder: newRouteBuilder,
      arguments: arguments,
    );
  }
}
