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
  group('HomeScreen', () {
    const showPincodeScreenTextButtonKey =
        Key('homeScreen_showPincodeScreen_textButton');
    const showQuizDialogTextButtonKey =
        Key('homeScreen_showQuizDialog_textButton');

    late MockNavigator navigator;

    setUpAll(() {
      registerFallbackValue(FakeRoute<Object?>());
      registerFallbackValue(FakeRoute<String>());
    });

    setUp(() {
      navigator = MockNavigator();
      when(() => navigator.push(any())).thenAnswer((_) async => null);
    });

    group('show pincode screen button', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpTest(
          builder: (context) {
            return const HomeScreen();
          },
        );

        expect(
          find.byKey(showPincodeScreenTextButtonKey),
          findsOneWidget,
        );
      });

      testWidgets('navigates to PincodeScreen when pressed', (tester) async {
        await tester.pumpTest(
          builder: (context) {
            return MockNavigatorProvider(
              navigator: navigator,
              child: const HomeScreen(),
            );
          },
        );

        await tester.tap(
          find.byKey(showPincodeScreenTextButtonKey),
        );

        verify(
          () => navigator.push(
            any(that: isRoute<String?>(named: '/pincode_screen')),
          ),
        ).called(1);
      });

      testWidgets('displays snackbar with selected pincode', (tester) async {
        when(() => navigator.push(
              any(that: isRoute<String?>(named: '/pincode_screen')),
            )).thenAnswer((_) async => '123456');

        await tester.pumpTest(
          builder: (context) {
            return MockNavigatorProvider(
              navigator: navigator,
              child: const HomeScreen(),
            );
          },
        );

        await tester.tap(find.byKey(showPincodeScreenTextButtonKey));
        await tester.pumpAndSettle();

        expect(
          find.widgetWithText(SnackBar, 'Pincode is "123456" 🔒'),
          findsOneWidget,
        );
      });

      testWidgets(
        'displays snackbar when no pincode was submitted',
        (tester) async {
          when(() => navigator.push(
                any(that: isRoute<String?>(named: '/pincode_screen')),
              )).thenAnswer((_) async => null);

          await tester.pumpTest(
            builder: (context) {
              return MockNavigatorProvider(
                navigator: navigator,
                child: const HomeScreen(),
              );
            },
          );

          await tester.tap(find.byKey(showPincodeScreenTextButtonKey));
          await tester.pumpAndSettle();

          expect(
            find.widgetWithText(SnackBar, 'No pincode submitted. 😲'),
            findsOneWidget,
          );
        },
      );
    });

    group('show quiz dialog button', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpTest(
          builder: (context) {
            return const HomeScreen();
          },
        );

        expect(
          find.byKey(showQuizDialogTextButtonKey),
          findsOneWidget,
        );
      });

      testWidgets('shows quiz dialog when pressed', (tester) async {
        await tester.pumpTest(
          builder: (context) {
            return MockNavigatorProvider(
              navigator: navigator,
              child: const HomeScreen(),
            );
          },
        );

        await tester.tap(find.byKey(showQuizDialogTextButtonKey));

        verify(() => navigator.push(any(that: isRoute<QuizOption?>())))
            .called(1);
      });

      testWidgets(
        'displays snackbar when pizza was selected',
        (tester) async {
          when(() => navigator.push(any(that: isRoute<QuizOption?>())))
              .thenAnswer((_) async => QuizOption.pizza);

          await tester.pumpTest(
            builder: (context) {
              return MockNavigatorProvider(
                navigator: navigator,
                child: const HomeScreen(),
              );
            },
          );

          await tester.tap(find.byKey(showQuizDialogTextButtonKey));
          await tester.pumpAndSettle();

          expect(
            find.widgetWithText(SnackBar, 'Pizza all the way! 🍕'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'displays snackbar when hamburger was selected',
        (tester) async {
          when(() => navigator.push(any(that: isRoute<QuizOption?>())))
              .thenAnswer((_) async => QuizOption.hamburger);

          await tester.pumpTest(
            builder: (context) {
              return MockNavigatorProvider(
                navigator: navigator,
                child: const HomeScreen(),
              );
            },
          );

          await tester.tap(find.byKey(showQuizDialogTextButtonKey));
          await tester.pumpAndSettle();

          expect(
            find.widgetWithText(SnackBar, 'Hamburger all the way! 🍔'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'displays snackbar when no answer was selected',
        (tester) async {
          when(() => navigator.push(any(that: isRoute<QuizOption?>())))
              .thenAnswer((_) async => null);

          await tester.pumpTest(
            builder: (context) {
              return MockNavigatorProvider(
                navigator: navigator,
                child: const HomeScreen(),
              );
            },
          );

          await tester.tap(find.byKey(showQuizDialogTextButtonKey));
          await tester.pumpAndSettle();

          expect(
            find.widgetWithText(SnackBar, 'No answer selected. 😲'),
            findsOneWidget,
          );
        },
      );
    });
  });
}
