//REMAINING: MEDIAQUERY, AND PLAY/PAUSE IN BUTTONS,

import 'package:flutter/material.dart';
import 'package:sound_sweep/audio_provider.dart';
import 'package:sound_sweep/audio_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => AudioProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sound Sweep',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AudioScreen(),
    );
  }
}
