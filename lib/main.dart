import 'package:flutter/material.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:habit_tracker/view/homepage/homepage.dart';
import 'package:provider/provider.dart';
import 'database/habit_database.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// initialize database
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();
  runApp (
      MultiProvider(
          providers:[ChangeNotifierProvider(create: (context) => HabitDatabase()),// habit provider
                     ChangeNotifierProvider(create: (context) => ThemeProvider()),// theme provider
          ],
  child: const MyApp()),
  ); // ChangeNotifierProvider
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        theme: Provider.of<ThemeProvider>(context).themeData);
  }
}
