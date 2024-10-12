//REMAINING: CHECK DELETE, CHECK POP, MEDIAQUERY, AND PLAY/PAUSE IN LIST

import 'package:flutter/material.dart';
import 'package:project_new/audio_provider.dart';
import 'package:project_new/audio_screen.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AudioScreen(),
    );
  }
}
