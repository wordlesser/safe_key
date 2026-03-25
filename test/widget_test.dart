import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:safe_key/src/features/auth/controller/auth_controller.dart';
import 'package:safe_key/src/features/passwords/controller/passwords_controller.dart';
import 'package:safe_key/src/shared/constants/app_theme.dart';

void main() {
  testWidgets('SafeKey providers render without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthController()),
          ChangeNotifierProvider(create: (_) => PasswordsController()),
        ],
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: Center(child: Text('SafeKey Test')),
          ),
        ),
      ),
    );
    expect(find.text('SafeKey Test'), findsOneWidget);
  });
}
