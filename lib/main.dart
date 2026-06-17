import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/routes/app_router.dart';
import 'app/theme/app_theme.dart';
import 'app/providers/theme_provider.dart';
import 'core/services/firebase_service.dart';
import 'core/services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  await Future.wait([
    Hive.openBox('auth'),
    Hive.openBox('workouts'),
    Hive.openBox('meals'),
    Hive.openBox('medicines'),
    Hive.openBox('appointments'),
    Hive.openBox('documents'),
    Hive.openBox('family'),
  ]);
  
  await FirebaseService.initialize();
  await FirestoreService.initialize();
  
  runApp(
    const ProviderScope(
      child: WellNestApp(),
    ),
  );
}

class WellNestApp extends ConsumerWidget {
  const WellNestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'WellNest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
