import 'package:flutter/cupertino.dart';

enum QuizOption { pizza, hamburger }

class QuizDialog extends StatelessWidget {
  const QuizDialog({super.key});

  static Future<QuizOption?> show(BuildContext context) {
    return showCupertinoDialog<QuizOption>(
      context: context,
      // Important for compatibility with MockNavigator.
      useRootNavigator: false,
      builder: (context) {
        return const QuizDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: const Text('Which food is the best?'),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(QuizOption.pizza),
          child: const Text('🍕'),
        ),
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(QuizOption.hamburger),
          child: const Text('🍔'),
        ),
      ],
    );
  }
}
