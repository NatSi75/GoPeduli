import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/splash_screen.dart';

class MobileApp extends StatelessWidget {
  const MobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoPeduli',
      theme: ThemeData(
        fontFamily: 'Inter', // ini yang bikin semua Text otomatis pakai Inter
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
