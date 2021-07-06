import 'package:example/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockingjay/mockingjay.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers.dart';

class MockNavigator extends Mock
    with MockNavigatorDiagnosticsMixin
    implements MockNavigatorBase {}

class FakeRoute<T> extends Fake implements Route<T> {}

void main() {
  group('PincodeScreen', () {
    late MockNavigator navigator;

    setUpAll(() {
      registerFallbackValue(FakeRoute<Object?>());
    });

    setUp(() {
      navigator = MockNavigator();
    });

    testWidgets('renders pincode text input', (tester) async {
      await tester.pumpTest(
        builder: (context) {
          return const PincodeScreen();
        },
      );

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets(
      'pops route with entered pincode when 6 digits have been entered',
      (tester) async {
        await tester.pumpTest(
          builder: (context) {
            return MockNavigatorProvider(
              navigator: navigator,
              child: const PincodeScreen(),
            );
          },
        );

        await tester.enterText(find.byType(TextField), '1234');
        verifyNever(() => navigator.pop('1234'));

        await tester.enterText(find.byType(TextField), '12345');
        verifyNever(() => navigator.pop('12345'));

        await tester.enterText(find.byType(TextField), '123456');
        verify(() => navigator.pop('123456')).called(1);
      },
    );
  });
}
