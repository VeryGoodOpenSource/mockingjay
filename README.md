# 🕊 mockingjay

[![Very Good Ventures](https://raw.githubusercontent.com/VeryGoodOpenSource/mockingjay/main/assets/vgv_logo.png)](https://verygood.ventures)

Developed with 💙 by [Very Good Ventures](https://verygood.ventures) 🦄

[![ci](https://github.com/VeryGoodOpenSource/mockingjay/workflows/mockingjay/badge.svg)](https://github.com/VeryGoodOpenSource/mockingjay/actions)
[![pub package](https://img.shields.io/pub/v/mockingjay.svg)](https://pub.dartlang.org/packages/mockingjay)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![style: very good analysis][badge]][badge_link]

---

A package that makes it easy to mock, test and verify navigation calls in Flutter. It works in tandem with [`mocktail`][mocktail], allowing you to mock a navigator the same way you would any other object, making it easier to test navigation behavior independently from the UI it's supposed to render.

## Usage

To use the package in your tests, add it to your dev dependencies in your `pubspec.yaml`:

```yaml
dev_dependencies:
  mockingjay: ^0.2.0
```

Then, in your tests, create a `MockNavigator` class like so:

```dart
import 'package:mockingjay/mockingjay.dart';

final navigator = MockNavigator();
```

Now you can create a new `MockNavigator` and pass it to a `MockNavigatorProvider`.

Any widget looking up the nearest `Navigator.of(context)` from that point will now receive the `MockNavigator`, allowing you to mock (using `when`) and `verify` any navigation calls. Use the included matchers to more easily match specific route names and types.

**Note**: make sure the `MockNavigatorProvider` is constructed **below** the `MaterialApp`. Otherwise, any `Navigator.of(context)` call will return a real `NavigatorState` instead of the mock.

## Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
        onPressed: () => Navigator.of(context).push(MySettingsPage.route()),
        child: const Text('Navigate'),
      ),
    );
  }
}

class MySettingsPage extends StatelessWidget {
  const MySettingsPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const MySettingsPage(),
      settings: const RouteSettings(name: '/settings'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

void main() {
  testWidgets('pushes SettingsPage when TextButton is tapped', (tester) async {
    final navigator = MockNavigator();
    when(() => navigator.push(any())).thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp(
        home: MockNavigatorProvider(
          navigator: navigator,
          child: const MyHomePage(),
        ),
      ),
    );

    await tester.tap(find.byType(TextButton));

    verify(
      () => navigator.push(any(that: isRoute<void>(whereName: equals('/settings')))),
    ).called(1);
  });
}
```

[very good analysis]: https://github.com/VeryGoodOpenSource/very_good_analysis
[badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[badge_link]: https://pub.dev/packages/mockingjay
[mocktail]: https://pub.dev/packages/mocktail
