import 'package:flutter_test/flutter_test.dart';

import 'package:movie_ticket/app.dart';
import 'package:movie_ticket/core/di/injection_container.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await init();
  });

  testWidgets('Movie app shows login content first', (WidgetTester tester) async {
    await tester.pumpWidget(const MovieTicketApp());
    await tester.pumpAndSettle();

    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Belum punya akun? Daftar di sini'), findsOneWidget);
  });
}
