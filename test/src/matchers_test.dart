import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/src/feature_matcher.dart';
import 'package:mockingjay/mockingjay.dart';

class NonModalRoute extends Mock implements TransitionRoute<void> {}

Future<void> expectToFail(
  dynamic actual,
  Matcher matcher, {
  required String withMessage,
}) async {
  var didNotFail = false;
  try {
    await expectLater(actual, matcher);
    didNotFail = true;
  } on TestFailure catch (error) {
    const whichClause = '   Which: ';
    final whichClauseIndex = error.message!.indexOf(whichClause);
    final reasonIndex = whichClauseIndex + whichClause.length;
    final reason = error.message!.substring(reasonIndex).trim();

    expect(reason, equals(withMessage));
  }

  if (didNotFail) {
    fail('TestFailure expected but not thrown');
  }
}

void main() {
  group('Matchers', () {
    group('isRoute', () {
      Route<T> createRoute<T>({
        String? name,
        Object? arguments,
        bool maintainState = true,
        bool fullscreenDialog = false,
      }) {
        return MaterialPageRoute<T>(
          settings: RouteSettings(name: name, arguments: arguments),
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          builder: (_) => const SizedBox(),
        );
      }

      group('constructor', () {
        test('wraps deprecated name value in equals matcher', () {
          expect(
            // ignore: deprecated_member_use_from_same_package
            isRoute(named: '/test'),
            isA<dynamic>().having(
              // ignore: avoid_dynamic_calls
              (dynamic m) => m.whereName,
              'whereName',
              isA<FeatureMatcher<String>>(),
            ),
          );
        });

        test('throws AssertionError when both whereSettings '
            'and whereName or whereArguments matchers are provided', () {
          expect(
            () => isRoute(
              whereSettings: isNotNull,
              whereName: isNotNull,
              whereArguments: isNotNull,
            ),
            throwsAssertionError,
          );
        });
      });

      group('without arguments', () {
        test('matches any route', () {
          expect(createRoute<dynamic>(), isRoute());
          expect(createRoute<String>(), isRoute());
          expect(createRoute<dynamic>(name: '/test'), isRoute());
          expect(createRoute<String>(name: '/test'), isRoute());
        });

        test('does not match anything that is not a route', () {
          expectToFail(
            1,
            isRoute(),
            withMessage: 'is not a route but an instance of `int`',
          );
          expectToFail(
            'a',
            isRoute(),
            withMessage: 'is not a route but an instance of `String`',
          );
          expectToFail(
            null,
            isRoute(),
            withMessage: 'is not a route but an instance of `Null`',
          );
          expectToFail(
            const SizedBox(),
            isRoute(),
            withMessage: 'is not a route but an instance of `SizedBox`',
          );
        });
      });

      group('with type argument', () {
        test('matches any route of correct type', () {
          expect(createRoute<String>(), isRoute<String>());
          expect(createRoute<String>(name: '/test'), isRoute<String>());
        });

        test('does not match anything that is not a route of that type', () {
          expectToFail(
            createRoute<dynamic>(),
            isRoute<String>(),
            withMessage: 'is a route of type `dynamic` instead of `String`',
          );
          expectToFail(
            createRoute<dynamic>(name: '/test'),
            isRoute<String>(),
            withMessage: 'is a route of type `dynamic` instead of `String`',
          );
          expectToFail(
            1,
            isRoute<String>(),
            withMessage: 'is not a route but an instance of `int`',
          );
        });
      });

      group('with whereSettings argument', () {
        test('matches any route with matching settings', () {
          expect(
            createRoute<dynamic>(),
            isRoute(whereSettings: equalsSettingsOf(createRoute<dynamic>())),
          );
          expect(
            createRoute<dynamic>(name: '/test'),
            isRoute(
              whereSettings: isA<RouteSettings>().having(
                (s) => s.name,
                'name',
                '/test',
              ),
            ),
          );
        });

        test('does not match anything that is not a route '
            'with matching settings', () {
          expectToFail(
            createRoute<dynamic>(name: '/test'),
            isRoute(whereSettings: equalsSettingsOf(createRoute<String>())),
            withMessage:
                "is a route where `settings` has `name` with value '/test'",
          );
          expectToFail(
            createRoute<dynamic>(name: '/other_name'),
            isRoute(
              whereSettings: equalsSettingsOf(
                createRoute<dynamic>(name: '/test'),
              ),
            ),
            withMessage: '''
is a route where `settings` has `name` with value '/other_name' which is different.
          Expected: /test
            Actual: /other_name ...
                     ^
           Differ at offset 1''',
          );
          expectToFail(
            1,
            isRoute(whereSettings: equalsSettingsOf(createRoute<dynamic>())),
            withMessage: 'is not a route but an instance of `int`',
          );
        });
      });

      group('with whereName argument', () {
        test('matches any route with correct name', () {
          expect(
            createRoute<dynamic>(name: '/test'),
            isRoute(whereName: equals('/test')),
          );
          expect(
            createRoute<String>(name: '/test'),
            isRoute(whereName: equals('/test')),
          );
        });

        test('does not match anything that is not a route with that name', () {
          expectToFail(
            createRoute<dynamic>(),
            isRoute(whereName: equals('/test')),
            withMessage:
                "is a route where the route's `name` is empty instead of '/test'",
          );
          expectToFail(
            createRoute<dynamic>(name: '/other_name'),
            isRoute(whereName: equals('/test')),
            withMessage: '''
is a route where the route's `name` is different.
          Expected: /test
            Actual: /other_name ...
                     ^
           Differ at offset 1''',
          );
          expectToFail(
            1,
            isRoute(whereName: equals('/test')),
            withMessage: 'is not a route but an instance of `int`',
          );
        });
      });

      group('with whereArguments argument', () {
        test('matches any route with correct arguments', () {
          expect(
            createRoute<dynamic>(arguments: {'a': 1}),
            isRoute(whereArguments: equals({'a': 1})),
          );
          expect(
            createRoute<String>(arguments: {'a': 1}),
            isRoute(whereArguments: equals({'a': 1})),
          );
        });

        test(
          'does not match anything that is not a route with same arguments',
          () {
            expectToFail(
              createRoute<dynamic>(arguments: {'a': 1}),
              isRoute(whereArguments: equals({'a': 2})),
              withMessage:
                  "is a route where the route's `arguments` "
                  "at location ['a'] is <1> instead of <2>",
            );
            expectToFail(
              createRoute<dynamic>(arguments: {'a': 1}),
              isRoute(whereArguments: equals({'b': 1})),
              withMessage:
                  "is a route where the route's `arguments` "
                  "is missing map key 'b'",
            );
            expectToFail(
              1,
              isRoute(whereArguments: equals({'a': 1})),
              withMessage: 'is not a route but an instance of `int`',
            );
          },
        );
      });

      group('with whereMaintainState argument', () {
        test('matches any route with matching maintainState argument', () {
          expect(createRoute<dynamic>(), isRoute(whereMaintainState: isTrue));
        });

        test('does not match anything that is not a route with matching '
            'maintainState argument', () {
          expectToFail(
            createRoute<dynamic>(),
            isRoute(whereMaintainState: isFalse),
            withMessage:
                'is a route where `maintainState` '
                'is true instead of false',
          );
          expectToFail(
            NonModalRoute(),
            isRoute(whereMaintainState: isTrue),
            withMessage:
                'is a route where `maintainState` '
                'is not a property on `NonModalRoute` and can only be used '
                'with `ModalRoute`s',
          );
          expectToFail(
            1,
            isRoute(whereMaintainState: isTrue),
            withMessage: 'is not a route but an instance of `int`',
          );
        });
      });

      group('with whereFullscreenDialog argument', () {
        test('matches any route with matching fullscreenDialog argument', () {
          expect(
            createRoute<dynamic>(fullscreenDialog: true),
            isRoute(whereFullscreenDialog: isTrue),
          );
        });

        test('does not match anything that is not a route with matching '
            'fullscreenDialog argument', () {
          expectToFail(
            createRoute<dynamic>(fullscreenDialog: true),
            isRoute(whereFullscreenDialog: isFalse),
            withMessage:
                'is a route where `fullscreenDialog` '
                'is true instead of false',
          );
          expectToFail(
            NonModalRoute(),
            isRoute(whereFullscreenDialog: isFalse),
            withMessage:
                'is a route where `fullscreenDialog` '
                'is not a property on `NonModalRoute` and can only be used '
                'with `PageRoute`s',
          );
          expectToFail(
            1,
            isRoute(whereFullscreenDialog: isTrue),
            withMessage: 'is not a route but an instance of `int`',
          );
        });
      });

      test('returns all relevant mismatches in one log', () {
        expectToFail(
          createRoute<dynamic>(
            name: '/other_name',
            arguments: {'b': 1},
            maintainState: false,
            fullscreenDialog: true,
          ),
          isRoute(
            whereName: equals('/test'),
            whereArguments: equals({'a': 1}),
            whereMaintainState: isTrue,
            whereFullscreenDialog: isFalse,
          ),
          withMessage: '''
is a route where
          - the route's `name` is different.
          Expected: /test
            Actual: /other_name ...
                     ^
           Differ at offset 1
          - the route's `arguments` is missing map key 'a'
          - `maintainState` is false instead of true
          - `fullscreenDialog` is true instead of false''',
        );
      });
    });
  });
}
