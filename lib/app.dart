import 'package:flutter/material.dart';
import 'package:pottery_diary/screens/pieces_list_screen.dart';

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
      home: const PiecesListScreen(),
    );
  }
}
