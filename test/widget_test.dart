import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_kabaadi/main.dart';

void main() {
  testWidgets('E-Kabaadi app launches splash screen and navigates to onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: EKabaadiApp(),
      ),
    );

    // Verify initial splash screen content
    expect(find.text('E-Kabaadi'), findsOneWidget);
    expect(find.text('Collect. Connect. Recycle.'), findsOneWidget);

    // Advance 3 seconds for splash timer & animations
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // Verify Onboarding screen content after timer navigation
    expect(find.text('Sell your scrap directly from your phone'), findsOneWidget);
  });
}
