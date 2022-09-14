import 'dart:async';

import 'package:example/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockingjay/mockingjay.dart';

import '../helpers.dart';

void main() {
  group('PincodeScreen', () {
    late MockNavigator navigator;

    setUp(() {
      navigator = MockNavigator();
    });

    testWidgets('.route renders PincodeScreen', (tester) async {
      late BuildContext context;
      await tester.pumpTest(
        builder: (appContext) {
          context = appContext;
          return const SizedBox();
        },
      );
      unawaited(Navigator.of(context).push(PincodeScreen.route()));
      await tester.pumpAndSettle();
      expect(find.byType(PincodeScreen), findsOneWidget);
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

    testWidgets(
      'clamps to 6 digits when more than 6 digits have been entered',
      (tester) async {
        await tester.pumpTest(
          builder: (context) {
            return MockNavigatorProvider(
              navigator: navigator,
              child: const PincodeScreen(),
            );
          },
        );

        await tester.enterText(find.byType(TextField), '1234567');
        verify(() => navigator.pop('123456')).called(1);
      },
    );

    testWidgets(
      'shows error when less than 6 digits have been entered',
      (tester) async {
        await tester.pumpTest(
          builder: (context) {
            return MockNavigatorProvider(
              navigator: navigator,
              child: const PincodeScreen(),
            );
          },
        );

        await tester.enterText(find.byType(TextField), '12345');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();
        expect(find.text('Pincode must be 6 digits long'), findsOneWidget);
      },
    );
  });
}
