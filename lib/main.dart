import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'src/features/auth/controller/auth_controller.dart';
import 'src/features/auth/pages/setup_password_page.dart';
import 'src/features/auth/pages/unlock_page.dart';
import 'src/features/auth/pages/welcome_page.dart';
import 'src/features/passwords/controller/passwords_controller.dart';
import 'src/features/passwords/pages/home_page.dart';
import 'src/shared/constants/app_theme.dart';
import 'src/shared/controllers/locale_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 禁止横屏（密码应用纵向使用体验更好）
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // 状态栏样式：白色背景下使用深色图标
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => PasswordsController()),
      ],
      child: const SafeKeyApp(),
    ),
  );
}

class SafeKeyApp extends StatelessWidget {
  const SafeKeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleController>().locale;
    return MaterialApp(
      title: 'SafeKey',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh'),
        Locale('zh', 'Hant'),
        Locale('en'),
      ],
      home: const _AppEntryPoint(),
    );
  }
}

/// 应用入口：负责初始化状态并监听生命周期
class _AppEntryPoint extends StatefulWidget {
  const _AppEntryPoint();

  @override
  State<_AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<_AppEntryPoint>
    with WidgetsBindingObserver {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  Future<void> _initialize() async {
    final auth = context.read<AuthController>();
    await auth.initialize();

    if (mounted) setState(() => _initialized = true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final auth = context.read<AuthController>();
    switch (state) {
      case AppLifecycleState.paused:
        // 只有真正进入后台（按 Home 键/切换 App）才触发锁定
        // inactive 是过渡态（系统弹窗、通知中心等），不应锁定
        auth.onAppBackgrounded();
        break;
      case AppLifecycleState.inactive:
        // 不处理：Face ID / passcode 系统弹窗会触发 inactive，不能因此锁定
        break;
      case AppLifecycleState.resumed:
        final wasUnlocked = auth.isUnlocked;
        auth.onAppResumed();
        // 如果解锁状态改变（被锁定），无需额外操作，UI 会响应 AuthState 变化
        if (wasUnlocked && auth.isUnlocked && auth.masterKey != null) {
          context.read<PasswordsController>().loadEntries(auth.masterKey!);
        }
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const _SplashScreen();
    }

    return Consumer<AuthController>(
      builder: (context, auth, _) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildScreen(auth),
        );
      },
    );
  }

  Widget _buildScreen(AuthController auth) {
    switch (auth.state) {
      case AuthState.initializing:
        return const _SplashScreen();

      case AuthState.firstRun:
        return const WelcomePage();

      case AuthState.settingUp:
        return const SetupPasswordPage();

      case AuthState.locked:
      case AuthState.lockedOut:
        return const UnlockPage();

      case AuthState.unlocked:
        return _UnlockedRoot(
          onUnlocked: () {
            final auth = context.read<AuthController>();
            if (auth.masterKey != null) {
              context
                  .read<PasswordsController>()
                  .loadEntries(auth.masterKey!);
            }
          },
        );
    }
  }
}

class _UnlockedRoot extends StatefulWidget {
  const _UnlockedRoot({required this.onUnlocked});

  final VoidCallback onUnlocked;

  @override
  State<_UnlockedRoot> createState() => _UnlockedRootState();
}

class _UnlockedRootState extends State<_UnlockedRoot> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onUnlocked());
  }

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.key_rounded,
                color: AppColors.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'SafeKey',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
