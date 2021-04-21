/// An experimental package that attempts to make it easy to mock Flutter's
/// navigator routes.
library mock_navigator;

import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:mockito/mockito.dart' as mockito;

/// A template fake route, useful for registering fallbacks when using the
/// `mocktail` package.
class FakeRoute<T> extends mocktail.Fake implements Route<T> {}

/// {@template mock_navigator_provider}
/// The widget that provides an instance of a [MockNavigator].
/// {@endtemplate}
class MockNavigatorProvider extends Navigator {
  /// {@macro mock_navigator_provider}
  const MockNavigatorProvider({
    Key? key,
    required this.child,
    required this.navigator,
  }) : super(key: key);

  /// The [MockNavigator] used to mock navigation calls.
  final MockNavigator navigator;

  /// The [Widget] to render.
  final Widget child;

  @override
  NavigatorState createState() {
    return _MockNavigatorState(navigator: navigator)..child = child;
  }

  @override
  RouteFactory? get onGenerateRoute {
    return (_) => MaterialPageRoute(builder: (_) => child);
  }
}

/// The navigator of which the behavior can be defined through using either the
/// [MocktailNavigator] or [MockitoNavigator].a
abstract class MockNavigator implements NavigatorState {}

/// The navigator of which the behavior can be defined through mocking using the
/// `mocktail` package.
class MocktailNavigator extends mocktail.Mock
    with _DiagnosticStringMixin
    implements MockNavigator {}

/// The navigator of which the behavior can be defined through mocking using the
/// `mockito` package.
class MockitoNavigator extends mocktail.Mock
    with _DiagnosticStringMixin
    implements MockNavigator {}

mixin _DiagnosticStringMixin on Object {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

class _MockNavigatorState extends NavigatorState {
  _MockNavigatorState({required this.navigator});

  MockNavigator navigator;
  Widget? child;

  @override
  Future<T?> push<T extends Object?>(Route<T> route) => navigator.push(route);

  @override
  Widget build(BuildContext context) => child!;
}
