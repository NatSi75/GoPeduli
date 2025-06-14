import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import 'providers/user_provider.dart';
import 'package:provider/provider.dart';

class MobileApp extends StatelessWidget {
  const MobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GoPeduli',
            theme: ThemeData(useMaterial3: true, fontFamily: 'Inter'),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
