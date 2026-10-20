import 'package:flutter_test/flutter_test.dart';
import 'package:payhas/main.dart';

void main() {
  testWidgets('App loads the guest and authentication entry screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PayhasApp());
    await tester.pumpAndSettle();

    expect(find.text('AKYL-YLMYŇ HYRYDARY'), findsOneWidget);
    expect(find.text('MYHMAN HÖKMÜNDE OÝNA'), findsOneWidget);
    expect(find.text('GIR'), findsOneWidget);
  });
}
