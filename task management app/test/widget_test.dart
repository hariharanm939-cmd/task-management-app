import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/services/notification_service.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    final notificationService = NotificationService();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TaskProvider()),
          Provider<NotificationService>.value(value: notificationService),
        ],
        child: const TaskManagerApp(),
      ),
    );

    // Verify that our app is locked initially.
    expect(find.text('Task Manager Locked'), findsOneWidget);
  });
}
