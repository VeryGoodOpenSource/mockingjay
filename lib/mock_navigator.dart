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
    return _MockNavigatorState(navigator: navigator)..child = child;
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

class _MockNavigatorState extends NavigatorState {
  _MockNavigatorState({required this.navigator});

  MockNavigatorBase navigator;
  Widget? child;

  @override
  Future<T?> push<T extends Object?>(Route<T> route) => navigator.push(route);

  @override
  Widget build(BuildContext context) => child!;
}
