import 'package:flutter/material.dart';
import '../widgets/navigation.dart';

class MobileApp extends StatelessWidget {
  const MobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoPeduli',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Navigation(),
    );
  }
}
