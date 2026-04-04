import 'package:flutter/material.dart';

class PotteryDiaryApp extends StatelessWidget {
  const PotteryDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pottery Diary',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B6B4A), // warm clay brown
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('Pottery Diary')),
      ),
    );
  }
}
