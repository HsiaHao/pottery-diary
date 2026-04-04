import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pottery_diary/app.dart';

void main() {
  testWidgets('app renders pieces list screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: PotteryDiaryApp()),
    );
    await tester.pump();
    expect(find.text('My Pieces'), findsOneWidget);
  });
}
