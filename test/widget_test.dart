import 'package:flutter_test/flutter_test.dart';
import 'package:luranapp/main.dart';

void main() {
  testWidgets('App launches splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const OfertaLocalApp());
    expect(find.text('OfertaLocal'), findsOneWidget);
  });
}
