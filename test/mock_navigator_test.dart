import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mock_navigator/mock_navigator.dart';
import 'package:mocktail/mocktail.dart';

extension on WidgetTester {
  Future<void> pumpTest(Widget widget) async {
    await pumpWidget(
      MaterialApp(
        title: 'Mock Navigator Test',
        home: Scaffold(
          body: widget,
        ),
      ),
    );
  }
}

void main() {
  group('MockNavigator', () {
    late MockNavigator navigator;

    setUpAll(() {
      registerFallbackValue<Route<Object?>>(FakeRoute<Object?>());
    });

    setUp(() {
      navigator = MocktailNavigator();
    });

    testWidgets('mocks .push calls', (tester) async {
      var pushCalled = 0;

      when(() => navigator.push(any())).thenAnswer((_) async {
        pushCalled++;
        return null;
      });

      await tester.pumpTest(
        MockNavigatorProvider(
          navigator: navigator,
          child: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const Text('I should not build.'),
                    ),
                  );
                },
                child: const Text('Trigger'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));

      expect(pushCalled, equals(1));
    });
  });
}
