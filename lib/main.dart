import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../screens/home_screen.dart';
import '../screens/completed_tasks_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  var box = await Hive.openBox('tasksBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, 
        scaffoldBackgroundColor: Colors.blueGrey[50],

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
        ),

        checkboxTheme: CheckboxThemeData(
          checkColor: WidgetStateProperty.all(Colors.white), 
          fillColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.blueGrey; // ✅ checked
              }
              return Colors.white; // ⬜ unchecked
            },
          ),
          overlayColor: WidgetStateProperty.all(Colors.transparent), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/completed': (context) => const CompletedTasksScreen(),
      },
    );
  }
}
