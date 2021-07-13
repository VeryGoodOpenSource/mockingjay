import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

void main() {
  group('Matchers', () {
    group('isRoute', () {
      Route<T> createRoute<T>([String? name]) {
        return MaterialPageRoute<T>(
          settings: RouteSettings(name: name),
          builder: (_) => const SizedBox(),
        );
      }

      group('without arguments', () {
        test('matches any route', () {
          expect(createRoute(), isRoute());
          expect(createRoute<String>(), isRoute());
          expect(createRoute('/test'), isRoute());
          expect(createRoute<String>('/test'), isRoute());
        });

        test('does not match anything that is not a route', () {
          expectToFail(1, isRoute(), withMessage: 'is not a route');
          expectToFail('a', isRoute(), withMessage: 'is not a route');
          expectToFail(null, isRoute(), withMessage: 'is not a route');
          expectToFail(
            const SizedBox(),
            isRoute(),
            withMessage: 'is not a route',
          );
        });
      });

      group('with name argument', () {
        test('matches any route with correct name', () {
          expect(createRoute('/test'), isRoute(named: '/test'));
          expect(createRoute<String>('/test'), isRoute(named: '/test'));
        });

        test('does not match anything that is not a route with that name', () {
          expectToFail(
            createRoute(),
            isRoute(named: '/test'),
            withMessage:
                'is a route with the wrong name (actually, no name at all)',
          );
          expectToFail(
            createRoute<String>(),
            isRoute(named: '/test'),
            withMessage:
                'is a route with the wrong name (actually, no name at all)',
          );
          expectToFail(
            createRoute('/other_name'),
            isRoute(named: '/test'),
            withMessage: 'is a route with the wrong name ("/other_name")',
          );
          expectToFail(
            1,
            isRoute(named: '/test'),
            withMessage: 'is not a route',
          );
          expectToFail(
            'a',
            isRoute(named: '/test'),
            withMessage: 'is not a route',
          );
          expectToFail(
            null,
            isRoute(named: '/test'),
            withMessage: 'is not a route',
          );
          expectToFail(
            const SizedBox(),
            isRoute(named: '/test'),
            withMessage: 'is not a route',
          );
        });
      });

      group('with type argument', () {
        test('matches any route of correct type', () {
          expect(createRoute<String>(), isRoute<String>());
          expect(createRoute<String>('/test'), isRoute<String>());
        });

        test('does not match anything that is not a route of that type', () {
          expectToFail(
            createRoute(),
            isRoute<String>(),
            withMessage:
                'is a route of the wrong type (MaterialPageRoute<dynamic>)',
          );
          expectToFail(
            createRoute('/test'),
            isRoute<String>(),
            withMessage:
                'is a route of the wrong type (MaterialPageRoute<dynamic>)',
          );
          expectToFail(1, isRoute<String>(), withMessage: 'is not a route');
          expectToFail('a', isRoute<String>(), withMessage: 'is not a route');
          expectToFail(null, isRoute<String>(), withMessage: 'is not a route');
          expectToFail(
            const SizedBox(),
            isRoute<String>(),
            withMessage: 'is not a route',
          );
        });
      });

      group('with name and type argument', () {
        test('matches any route with correct name and type', () {
          expect(createRoute<String>('/test'), isRoute<String>(named: '/test'));
        });

        test('does not match anything that is not a route of that type', () {
          expectToFail(
            createRoute(),
            isRoute<String>(named: '/test'),
            withMessage:
                'is a route of the wrong type (MaterialPageRoute<dynamic>) '
                'and name (actually, no name at all)',
          );
          expectToFail(
            createRoute('/test'),
            isRoute<String>(named: '/test'),
            withMessage:
                'is a route of the wrong type (MaterialPageRoute<dynamic>)',
          );
          expectToFail(
            createRoute<String>(),
            isRoute<String>(named: '/test'),
            withMessage:
                'is a route with the wrong name (actually, no name at all)',
          );
          expectToFail(
            1,
            isRoute<String>(named: '/test'),
            withMessage: 'is not a route',
          );
          expectToFail(
            'a',
            isRoute<String>(named: '/test'),
            withMessage: 'is not a route',
          );
          expectToFail(
            null,
            isRoute<String>(named: '/test'),
            withMessage: 'is not a route',
          );
          expectToFail(
            const SizedBox(),
            isRoute<String>(named: '/test'),
            withMessage: 'is not a route',
          );
        });
      });
    });
  });
}

Future<void> expectToFail(
  dynamic actual,
  Matcher matcher, {
  required String withMessage,
}) async {
  try {
    await expectLater(actual, matcher);
    fail('TestFailure expected but not thrown');
  } on TestFailure catch (error) {
    expect(error.message, contains(withMessage));
  }
}
