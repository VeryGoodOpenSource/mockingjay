import 'package:example/app.dart';
import 'package:example/ui/ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('App', () {
    testWidgets('renders HomeScreen by default', (tester) async {
      await tester.pumpTest(
        builder: (context) {
          return const App();
        },
      );

      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
