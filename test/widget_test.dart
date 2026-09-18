import 'package:flutter_test/flutter_test.dart';
import 'package:payhas/main.dart';

void main() {
  testWidgets('App loads Home Screen with Turkmen UI elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PayhasApp());
    await tester.pumpAndSettle();

    // Verify Title & Subtitle in Turkmen
    expect(find.text('SÖZİ TAP'), findsOneWidget);
    expect(find.text('Paýhasyňy syna!'), findsOneWidget);

    // Verify Main Action Buttons
    expect(find.text('OÝNA'), findsOneWidget);
    expect(find.text('GÜNDELİK SORAG'), findsOneWidget);

    // Verify Secondary Menu Buttons
    expect(find.text('Derejeler'), findsOneWidget);
    expect(find.text('Reýting'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });
}
