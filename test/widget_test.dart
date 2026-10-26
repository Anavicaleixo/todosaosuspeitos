import 'package:flutter_test/flutter_test.dart';
import 'package:case_files/main.dart';

void main() {
  testWidgets('Smoke test app initialization', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CaseFilesApp());
  });
}
