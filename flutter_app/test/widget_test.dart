// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:taskpilot/main.dart';

void main() {
  testWidgets('Opens Scrollable Views screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskPilotApp());
    await tester.pumpAndSettle();

    expect(find.text('Responsive Layout'), findsOneWidget);

    await tester.tap(find.byTooltip('Open Scrollable Views'));
    await tester.pumpAndSettle();

    expect(find.text('Scrollable Views'), findsOneWidget);
    expect(find.text('ListView (horizontal)'), findsOneWidget);
    expect(find.text('GridView (responsive)'), findsOneWidget);
  });
}
