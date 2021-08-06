import 'package:example/ui/ui.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mockingjay Example',
      color: Colors.black,
      theme: ThemeData.light().copyWith(primaryColor: Colors.black),
      darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.black),
      home: const HomeScreen(),
    );
  }
}
