import 'package:flutter_test/flutter_test.dart';
import 'package:proactiva_mobile/main.dart';

void main() {
  testWidgets('ProActiva app initial smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProActivaApp(isLoggedIn: false));
    expect(find.byType(ProActivaApp), findsOneWidget);
  });
}
