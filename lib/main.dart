import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gopeduli/dashboard/features/authentication/authentication_repository.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';

import 'web_app.dart';
import 'mobile_app.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized before using any plugins
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    // Initialize GetX Local Storage
    await GetStorage.init();

    // Initialize Firebase & Authentication Repository
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) => Get.put(AuthenticationRepository()));

    // Remove # sign from url
    setPathUrlStrategy();
    runApp(const WebApp());
  } else if (Platform.isAndroid && Platform.isIOS) {
    runApp(const MobileApp());
  } else {
    runApp(const MobileApp());
  }
}
