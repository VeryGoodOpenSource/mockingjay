import 'dart:io';

import 'package:example/ui/ui.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<void> _showPincodeScreen(BuildContext context) async {
    final result = await Navigator.of(context).push(PincodeScreen.route());

    late final String snackBarContent;

    if (result == null) {
      snackBarContent = 'No pincode submitted. 😲';
    } else {
      snackBarContent = 'Pincode is "$result" 🔒';
    }

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(snackBarContent),
        ),
      );
  }

  Future<void> _showQuizDialog(BuildContext context) async {
    final result = await QuizDialog.show(context);

    late final String snackBarContent;

    if (result == null) {
      snackBarContent = 'No answer selected. 😲';
    } else if (result == QuizOption.pizza) {
      snackBarContent = 'Pizza all the way! 🍕';
    } else if (result == QuizOption.hamburger) {
      snackBarContent = 'Hamburger all the way! 🍔';
    }

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(snackBarContent),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monospaceFontFamily = Platform.isIOS ? 'Courier' : 'monospace';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mockingjay Example'),
      ),
      body: Center(
        child: DefaultTextStyle.merge(
          textAlign: TextAlign.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'This is an example app showcasing the Mockingjay library.',
                    style: theme.textTheme.headline6,
                  ),
                  const SizedBox(height: 8.0),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Use one of the following buttons to trigger a '
                              'navigation change.\n'
                              'Check out the test files in the ',
                        ),
                        TextSpan(
                          text: 'test/',
                          style: TextStyle(
                            fontFamily: monospaceFontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: ' directory to see how the library works.',
                        ),
                      ],
                    ),
                    style: TextStyle(color: theme.disabledColor),
                  ),
                  const SizedBox(height: 32.0),
                  TextButton.icon(
                    key: const Key('homeScreen_showPincodeScreen_textButton'),
                    onPressed: () => _showPincodeScreen(context),
                    label: const Text('Show Pincode Screen'),
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                  TextButton.icon(
                    key: const Key('homeScreen_showQuizDialog_textButton'),
                    onPressed: () => _showQuizDialog(context),
                    label: const Text('Show Quiz Dialog'),
                    icon: const Icon(Icons.view_array),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
