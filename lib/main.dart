import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const ProviderScope(child: FrogGameApp()));
}

class FrogGameApp extends StatelessWidget {
  const FrogGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '青蛙跳井',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.light,
        ),
        fontFamily: 'PingFang SC',
      ),
      home: const WelcomeScreen(),
    );
  }
}
