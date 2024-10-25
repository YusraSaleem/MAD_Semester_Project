import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_sweep/audio_provider.dart';
import 'package:sound_sweep/splash_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => AudioProvider(),
    child: const MyApp(),
  ));
  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sound Sweep',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
