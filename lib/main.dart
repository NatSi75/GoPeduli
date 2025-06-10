import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'firebase_options.dart';
import 'web_app.dart';
import 'mobile_app.dart';

import 'dashboard/features/authentication/authentication_repository.dart';
import 'providers/user_provider.dart'; // Pastikan path ini benar

Future<void> main() async {
  // Ensure that plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize local storage if web
  if (kIsWeb) {
    await GetStorage.init();

    // Re-initialize Firebase and inject dependencies
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) => Get.put(AuthenticationRepository()));

    // Remove # from URL
    setPathUrlStrategy();

    // Run WebApp with Provider
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: const WebApp(),
      ),
    );
  } else if (Platform.isAndroid || Platform.isIOS) {
    // Run MobileApp with Provider
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: const MobileApp(),
      ),
    );
  } else {
    // Default to MobileApp with Provider for other platforms
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: const MobileApp(),
      ),
    );
  }
}
