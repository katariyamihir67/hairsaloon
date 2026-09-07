import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: EliteSalonApp(),
    ),
  );
}

class EliteSalonApp extends ConsumerWidget {
  const EliteSalonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Elite Salon',
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Enforce dark premium theme
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
