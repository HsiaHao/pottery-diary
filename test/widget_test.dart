import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pottery_diary/app.dart';

void main() {
  testWidgets('app renders pottery diary home', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: PotteryDiaryApp()),
    );
    await tester.pump();
    expect(find.text('Pottery Diary'), findsOneWidget);
    expect(find.text('Handcrafted\nPieces'), findsOneWidget);
  });
}
