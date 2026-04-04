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
          seedColor: const Color(0xFF8B6B4A),
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFFF7F4F0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F4F0),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF2C2218),
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Color(0xFF5C4A3A)),
        ),
      ),
      home: const PiecesListScreen(),
    );
  }
}
