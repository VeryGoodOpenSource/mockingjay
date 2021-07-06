# 🕊 mockingjay

[![Very Good Ventures](https://raw.githubusercontent.com/VeryGoodOpenSource/mockingjay/main/assets/vgv_logo.png)](https://verygood.ventures)

Developed with 💙 by [Very Good Ventures](https://verygood.ventures) 🦄

[![ci](https://github.com/jeroen-meijer/mockingjay/workflows/ci/badge.svg)](https://github.com/jeroen-meijer/mockingjay/actions)
[![pub package](https://img.shields.io/pub/v/mockingjay.svg)](https://pub.dartlang.org/packages/mockingjay)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![style: very good analysis][badge]][badge_link]

---

This is an experimental package that makes it easy to mock, test and verify navigation calls in Flutter. It works in tandem with [`mocktail`][mocktail] and [`mockito`][mockito], allowing you to mock a navigator the same way you would any other object, making it easier to test navigation behavior independently from the UI it's supposed to render.

## Usage

To use the package in your tests, add it to your dev dependencies in your `pubspec.yaml`:

```yaml
dev_dependencies:
  mockingjay: ^0.1.0
```

Then, in your tests, create a `MockNavigator` class like so:

```dart
import 'package:mocktail/mocktail.dart';
// If you're using mockito, import that instead.
// import 'package:mockito/mockito.dart';

class MockNavigator extends Mock
    with MockNavigatorDiagnosticsMixin
    implements MockNavigatorBase {}
```

Now you can create a new `MockNavigator` and pass it to a `MockNavigatorProvider`.

Any widget looking up the nearest `Navigator.of(context)` from that point will now receive the `MockNavigator`, allowing you to mock (using `when`) and `verify` any navigation calls. Use the included matchers to more easily match specific route names and types.

If you're using `mocktail`, it's important to also set a fake fallback `Route` and to mock any navigation calls you might use in your tests.

**Note**: make sure the `MockNavigatorProvider` is constructed **below** the `MaterialApp`. Otherwise, any `Navigator.of(context)` call will return a real `NavigatorState` instead of the mock.

```dart
class MockNavigator extends Mock
    with MockNavigatorDiagnosticsMixin
    implements MockNavigatorBase {}

class FakeRoute<T> extends Fake implements Route<T> {}

void main() {
  late MockNavigator navigator;

  setUpAll(() {
    registerFallbackValue<Route<Object?>>(FakeRoute<Object?>());
  });

  setUp(() {
    navigator = MockNavigator();
    when(() => navigator.push(any())).thenAnswer((_) async => null);
  });

  group('MyButton', () {
    testWidgets(
      'pushes a new screen when button is pressed',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MockNavigatorProvider(
              navigator: navigator,
              child: Scaffold(
                body: MyButton(),
              ),
            ),
          ),
        );

        await tester.tap(find.byType(MyButton));
        verify(
          () => navigator.push(any(that: isRoute<void>(named: '/second_screen'))),
        ).called(1);
      },
    );
  });
}
```

[very good analysis]: https://github.com/VeryGoodOpenSource/very_good_analysis
[badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[badge_link]: https://pub.dev/packages/mockingjay
[mocktail]: https://pub.dev/packages/mocktail
[mockito]: https://pub.dev/packages/mockito
