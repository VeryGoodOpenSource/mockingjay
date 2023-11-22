# 🕊 mockingjay

[![Very Good Ventures][logo_white]][very_good_ventures_link_dark]
[![Very Good Ventures][logo_black]][very_good_ventures_link_light]

Developed with 💙 by [Very Good Ventures][very_good_ventures_link] 🦄

[![ci][ci_badge]][ci_link]
[![coverage][coverage_badge]][ci_link]
[![pub package][pub_badge]][pub_link]
[![License: MIT][license_badge]][license_link]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_badge_link]

---

A package that makes it easy to mock, test and verify navigation calls in Flutter. It works in tandem with [`mocktail`][mocktail], allowing you to mock a navigator the same way you would any other object, making it easier to test navigation behavior independently from the UI it's supposed to render.

## Usage

To use the package in your tests, install it via `dart pub add`:

```shell
dart pub add dev:mockingjay
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
  const MyHomePage({super.key});

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
  const MySettingsPage({super.key});

  static Route<void> route() {
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
    when(navigator.canPop).thenReturn(true);
    when(() => navigator.push<void>(any())).thenAnswer((_) async {});

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
      () => navigator.push<void>(
        any(
          that: isRoute<void>(
            whereName: equals('/settings'),
          ),
        ),
      ),
    ).called(1);
  });
}

```

[ci_badge]: https://github.com/VeryGoodOpenSource/mockingjay/workflows/mockingjay/badge.svg
[ci_link]: https://github.com/VeryGoodOpenSource/mockingjay/actions
[coverage_badge]: https://raw.githubusercontent.com/VeryGoodOpenSource/mockingjay/main/coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mocktail]: https://pub.dev/packages/mocktail
[pub_badge]: https://img.shields.io/pub/v/mockingjay.svg
[pub_link]: https://pub.dartlang.org/packages/mockingjay
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_badge_link]: https://pub.dev/packages/very_good_analysis
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
