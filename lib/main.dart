import 'package:flutter/material.dart';
import 'package:minimal_tracker/database/habit_database.dart';
import 'package:minimal_tracker/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/home_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // INITIALISE DATABASE
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();

  runApp(
      MultiProvider(providers: [

        // Theme Provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),

        // Habit Provider
        ChangeNotifierProvider(create: (context) => HabitDatabase()),
        
        ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

