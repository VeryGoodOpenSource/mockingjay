/// An experimental package that attempts to make it easy to mock Flutter's
/// navigator routes.
library mock_navigator;

import 'package:flutter/material.dart';

/// {@template mock_navigator_provider}
/// The widget that provides an instance of a [MockNavigatorBase].
/// {@endtemplate}
class MockNavigatorProvider extends Navigator {
  /// {@macro mock_navigator_provider}
  const MockNavigatorProvider({
    Key? key,
    required this.child,
    required this.navigator,
  }) : super(key: key);

  /// The mock navigator used to mock navigation calls.
  final MockNavigatorBase navigator;

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
    return (_) => MaterialPageRoute(builder: (_) => child);
  }
}

/// The navigator of which the behavior can be defined through mocking.
///
///
/// ```dart
/// import 'package:mockito/mockito.dart';
/// // OR
/// import 'package:mocktail/mocktail.dart';
///
/// class MockNavigator extends Mock
///     with MockNavigatorDiagnosticsMixin
///     implements MockNavigatorBase {}
/// ```
abstract class MockNavigatorBase implements NavigatorState {}

/// A mixin necessary when implementing a [MockNavigatorBase].
mixin MockNavigatorDiagnosticsMixin on Object {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

/// Internal class that imitates a [NavigatorState] and maps all the real
/// [NavigatorState] methods to the mock methods for use in testing.
class _MockNavigatorState extends NavigatorState {
  _MockNavigatorState(this._navigator);

  final MockNavigatorBase _navigator;
  Widget? _child;

  @override
  Widget build(BuildContext context) => _child!;

  @override
  Future<T?> push<T extends Object?>(Route<T> route) {
    return _navigator.push<T>(route);
  }

  @override
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
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
    return _navigator.pushReplacement<T, TO>(
      newRoute,
      result: result,
    );
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
  Future<T?> pushAndRemoveUntil<T extends Object?>(
    Route<T> newRoute,
    RoutePredicate predicate,
  ) {
    return _navigator.pushAndRemoveUntil<T>(
      newRoute,
      predicate,
    );
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
    return _navigator.restorablePush<T>(
      routeBuilder,
      arguments: arguments,
    );
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
    return _navigator.restorablePushNamed<T>(
      routeName,
      arguments: arguments,
    );
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
    required Route oldRoute,
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
    required Route anchorRoute,
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
