import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'services/firebase_service.dart';
import 'services/prefs_service.dart';
import 'services/security_service.dart';
import 'services/iap_service.dart';
import 'services/update_service.dart';
import 'ui/router/app_router.dart';
import 'ui/widgets/connectivity_wrapper.dart';
import 'core/theme/app_theme.dart';
import 'package:upgrader/upgrader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode
        ? AndroidDebugProvider()
        : AndroidPlayIntegrityProvider(),
    providerApple: kDebugMode
        ? AppleDebugProvider()
        : AppleDeviceCheckProvider(),
  );

  await FirebaseService.initOfflinePersistence();
  await PrefsService.instance.init();
  await SecurityService.instance.init();
  
  // Trigger Android In-App Update check
  UpdateService.instance.checkForUpdates();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ProviderScope(child: BizDocxApp()));
}

class BizDocxApp extends ConsumerWidget {
  const BizDocxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    // Initialize IAP when user logs in
    ref.listen(currentUserProvider, (previous, next) {
      if (next != null && previous?.uid != next.uid) {
        IapService.instance.init(next.uid);
      }
    });

    return MaterialApp.router(
      title: 'BizDocx',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('es'),
      ],
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ConnectivityWrapper(
          child: UpgradeAlert(
            child: child!,
          ),
        );
      },
    );
  }
}
