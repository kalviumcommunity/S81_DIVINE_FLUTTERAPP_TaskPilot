import 'package:flutter/material.dart';
import 'screens/task_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Bridge Dashboard',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF3713EC),
        scaffoldBackgroundColor: const Color(0xFF131022),
        fontFamily: 'Courier',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
            .copyWith(secondary: const Color(0xFFFF6B00)),
      ),
      home: const TaskDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}
