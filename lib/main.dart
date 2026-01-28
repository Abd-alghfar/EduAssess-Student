import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/presentation/providers/auth_notifier.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/lessons/presentation/screens/lessons_screen.dart';
import 'core/providers/connectivity_provider.dart';
import 'core/services/update_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://oqocrskourawlimqjvqc.supabase.co',
    anonKey: 'sb_publishable_NDqUApsk1HiBm2cJZPfRnQ_b73AdaYk',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Student Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const UpdateChecker(child: AppHome()),
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Consumer(
                builder: (context, ref, _) {
                  final connectivity = ref.watch(connectivityStatusProvider);
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(0, 1),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOutBack,
                                    ),
                                  ),
                              child: child,
                            ),
                          );
                        },
                    child: connectivity.maybeWhen(
                      data: (status) {
                        if (status == ConnectivityStatus.isDisconnected) {
                          return Material(
                            key: const ValueKey('disconnected_banner'),
                            color: Colors.transparent,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red.shade900.withOpacity(0.95),
                                      Colors.red.shade700.withOpacity(0.95),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1.5,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.wifi_off_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    SizedBox(width: 16),
                                    Flexible(
                                      child: Text(
                                        'عذراً، لا يوجد اتصال بالإنترنت حالياً.\nيرجى التحقق من الشبكة للمتابعة.',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink(
                          key: ValueKey('connected_state'),
                        );
                      },
                      orElse: () =>
                          const SizedBox.shrink(key: ValueKey('loading_state')),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class AppHome extends ConsumerWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    return user == null ? const LoginScreen() : const LessonsScreen();
  }
}

class UpdateChecker extends StatefulWidget {
  final Widget child;
  const UpdateChecker({super.key, required this.child});

  @override
  State<UpdateChecker> createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends State<UpdateChecker> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateService.checkForUpdates(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
