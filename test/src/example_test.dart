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
      () => navigator.push(any(that: isRoute<void>(named: '/settings'))),
    ).called(1);
  });
}
