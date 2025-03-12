import 'package:flutter/widgets.dart';
import 'package:mockingjay/src/matcher_extensions.dart';
import 'package:test/test.dart';

/// Returns a matcher that matches [Route]s.
///
/// The optional type [T] is the return type of the route. In most cases, this
/// will be `void`, and can be omitted.
///
/// Additional matchers can be provided, such as [whereSettings], [whereName],
/// [whereArguments], [whereMaintainState] and [whereFullscreenDialog].
/// ```dart
/// expect(fooRoute, isRoute(whereName: equals('/home')));
///
/// verify(
///   () => navigator.push(any(that: isRoute<void>(whereName: equals('/home')))),
/// ).called(1);
///
/// ```
Matcher isRoute<T extends Object?>({
  @Deprecated('Use `whereName` instead') String? named,
  Matcher? whereSettings,
  Matcher? whereName,
  Matcher? whereArguments,
  Matcher? whereMaintainState,
  Matcher? whereFullscreenDialog,
}) {
  // Remove once `named` argument is removed.
  if (whereName == null && named != null) {
    // ignore: parameter_assignments
    whereName = equals(named);
  }

  assert(
    whereSettings == null || (whereName == null && whereArguments == null),
    'Cannot specify both `whereSettings` and `whereName` or `whereArguments`',
  );

  return _RouteMatcher<T>(
    whereSettings: whereSettings,
    whereName: whereName,
    whereArguments: whereArguments,
    whereMaintainState: whereMaintainState,
    whereFullscreenDialog: whereFullscreenDialog,
  );
}

/// Returns a matcher that matches the [RouteSettings] from the given [route].
Matcher equalsSettingsOf(Route<dynamic> route) {
  return isA<RouteSettings>()
      .having((s) => s.name, 'name', equals(route.settings.name))
      .having(
        (s) => s.arguments,
        'arguments',
        equals(route.settings.arguments),
      );
}

class _RouteMatcher<T> extends Matcher {
  const _RouteMatcher({
    this.whereSettings,
    this.whereName,
    this.whereArguments,
    this.whereMaintainState,
    this.whereFullscreenDialog,
  });

  final Matcher? whereSettings;
  final Matcher? whereName;
  final Matcher? whereArguments;
  final Matcher? whereMaintainState;
  final Matcher? whereFullscreenDialog;

  bool get hasTypeArgument => T != dynamic;

  bool get hasSettingsMatcher => whereSettings != null;

  bool get hasNameMatcher => whereName != null;

  bool get hasArgumentsMatcher => whereArguments != null;

  bool get hasMaintainStateMatcher => whereMaintainState != null;

  bool get hasFullscreenDialogMatcher => whereFullscreenDialog != null;

  bool get hasAnyMatchers =>
      hasSettingsMatcher ||
      hasNameMatcher ||
      hasArgumentsMatcher ||
      hasMaintainStateMatcher ||
      hasFullscreenDialogMatcher;

  /// Takes an [input] string that looks like "FooBarRoute<MyType>" and extracts
  /// the part "MyType".
  ///
  /// If the `Route<` part cannot be found, it returns the input string
  /// unchaged.
  ///
  /// If generic types are nested, they will be captured as well.
  ///
  /// ```dart
  /// _extractRouteTypeArgument("FooRoute<A>") == "A"
  /// _extractRouteTypeArgument("BarRoute<A<B>>") == "A<B>"
  /// _extractRouteTypeArgument("BazRoute<A<B<C>>>") == "A<B<C>>"
  ///
  /// _extractRouteTypeArgument("MyThing<A>") == "MyThing<A>"
  /// ```
  String _extractRouteTypeArgument(String input) {
    const routeTypeString = 'Route<';
    final routeTypeIndex = input.indexOf(routeTypeString);
    if (routeTypeIndex == -1) {
      return input;
    }

    final startIndex = routeTypeIndex + routeTypeString.length;
    final endIndex = input.lastIndexOf('>');
    return input.substring(startIndex, endIndex);
  }

  /// Joins the given strings using a comma and space.
  /// The last two strings are joined using "and".
  ///
  /// ```dart
  /// _naturallyJoin(['a', 'b', 'c', 'd']) == 'a, b, c and d'
  /// ```
  String _naturallyJoin(List<String> strings) {
    if (strings.isEmpty) {
      return '';
    } else if (strings.length == 1) {
      return strings[0];
    } else if (strings.length == 2) {
      return '${strings[0]} and ${strings[1]}';
    } else {
      return '${strings[0]}, ${_naturallyJoin(strings.sublist(1))}';
    }
  }

  @override
  Description describe(Description description) {
    var dsc = description.add('a route');
    if (hasTypeArgument) {
      dsc = dsc.add(' of type `$T`');
    }

    if (hasAnyMatchers) {
      final matcherDescriptions = <String>[];

      if (hasSettingsMatcher) {
        matcherDescriptions.add(
          '`settings` is ${whereSettings!.describeAsString()}',
        );
      }
      if (hasNameMatcher) {
        matcherDescriptions.add(
          "the route's `name` is ${whereName!.describeAsString()}",
        );
      }
      if (hasArgumentsMatcher) {
        matcherDescriptions.add(
          "the route's `arguments` is ${whereArguments!.describeAsString()}",
        );
      }
      if (hasMaintainStateMatcher) {
        matcherDescriptions.add(
          '`maintainState` is ${whereMaintainState!.describeAsString()}',
        );
      }
      if (hasFullscreenDialogMatcher) {
        matcherDescriptions.add(
          '`fullscreenDialog` is ${whereFullscreenDialog!.describeAsString()}',
        );
      }

      if (matcherDescriptions.isNotEmpty) {
        dsc = dsc.add(' where ${_naturallyJoin(matcherDescriptions)}');
      }
    }

    return dsc;
  }

  @override
  bool matches(dynamic item, Map<dynamic, dynamic> matchState) {
    if (item is Route) {
      final typeMatches = !hasTypeArgument || item is Route<T>;

      final settingsMatches =
          !hasSettingsMatcher ||
          whereSettings!.matches(item.settings, matchState);
      final nameMatches =
          !hasNameMatcher || whereName!.matches(item.settings.name, matchState);
      final argumentsMatches =
          !hasArgumentsMatcher ||
          whereArguments!.matches(item.settings.arguments, matchState);
      final maintainStateMatches =
          !hasMaintainStateMatcher ||
          (item is ModalRoute &&
              whereMaintainState!.matches(item.maintainState, matchState));
      final fullscreenDialogMatches =
          !hasFullscreenDialogMatcher ||
          (item is PageRoute &&
              whereFullscreenDialog!.matches(
                item.fullscreenDialog,
                matchState,
              ));

      return typeMatches &&
          settingsMatches &&
          nameMatches &&
          argumentsMatches &&
          maintainStateMatches &&
          fullscreenDialogMatches;
    } else {
      return false;
    }
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map<dynamic, dynamic> matchState,
    bool verbose,
  ) {
    if (item is! Route) {
      return mismatchDescription.add(
        'is not a route but '
        'an instance of `${item.runtimeType}`',
      );
    }

    final typeMatches = !hasTypeArgument || item is Route<T>;

    final settingsMatches =
        !hasSettingsMatcher ||
        whereSettings!.matches(item.settings, matchState);
    final nameMatches =
        !hasNameMatcher || whereName!.matches(item.settings.name, matchState);
    final argumentsMatches =
        !hasArgumentsMatcher ||
        whereArguments!.matches(item.settings.arguments, matchState);
    final maintainStateMatches =
        !hasMaintainStateMatcher ||
        (item is ModalRoute &&
            whereMaintainState!.matches(item.maintainState, matchState));
    final fullscreenDialogMatches =
        !hasFullscreenDialogMatcher ||
        (item is PageRoute &&
            whereFullscreenDialog!.matches(item.fullscreenDialog, matchState));

    var dsc = mismatchDescription.add('is a route');

    if (!typeMatches) {
      final routeType = _extractRouteTypeArgument(item.runtimeType.toString());
      dsc = dsc.add(' of type `$routeType` instead of `$T`');
    }

    if (hasAnyMatchers) {
      final mismatchDescriptions = <String>[];

      if (!settingsMatches) {
        final mismatch = whereSettings!.describeMismatchAsString(
          item.settings,
          matchState,
          verbose: verbose,
        );
        mismatchDescriptions.add('`settings` $mismatch');
      }
      if (!nameMatches) {
        final name = item.settings.name;
        if (name == null || name.isEmpty) {
          mismatchDescriptions.add(
            "the route's `name` is empty "
            'instead of ${whereName!.describeAsString()}',
          );
        } else {
          final mismatch = whereName!.describeMismatchAsString(
            name,
            matchState,
            verbose: verbose,
          );
          mismatchDescriptions.add("the route's `name` $mismatch");
        }
      }
      if (!argumentsMatches) {
        final mismatch = whereArguments!.describeMismatchAsString(
          item.settings.arguments,
          matchState,
          verbose: verbose,
        );
        mismatchDescriptions.add("the route's `arguments` $mismatch");
      }
      if (!maintainStateMatches) {
        final mismatch =
            item is! ModalRoute
                ? 'is not a property on `${item.runtimeType}` and can only be used '
                    'with `ModalRoute`s'
                : whereMaintainState!.describeMismatchAsString(
                  item.maintainState,
                  matchState,
                  verbose: verbose,
                );
        mismatchDescriptions.add('`maintainState` $mismatch');
      }
      if (!fullscreenDialogMatches) {
        final mismatch =
            item is! PageRoute
                ? 'is not a property on `${item.runtimeType}` and can only be used '
                    'with `PageRoute`s'
                : whereFullscreenDialog!.describeMismatchAsString(
                  item.fullscreenDialog,
                  matchState,
                  verbose: verbose,
                );
        mismatchDescriptions.add('`fullscreenDialog` $mismatch');
      }

      if (mismatchDescriptions.length == 1) {
        dsc = dsc.add(' where ${mismatchDescriptions.first}');
      } else if (mismatchDescriptions.isNotEmpty) {
        final mismatches = mismatchDescriptions.map((m) => '- $m').join('\n');
        dsc = dsc.add(' where\n$mismatches');
      }
    }

    return dsc;
  }
}
