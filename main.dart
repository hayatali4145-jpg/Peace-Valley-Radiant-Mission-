import 'package:flutter/material.dart';
import 'db.dart';
import 'screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDb.instance.database;
  runApp(const SchoolApp());
}

class SchoolApp extends StatefulWidget {
  const SchoolApp({super.key});
  @override
  State<SchoolApp> createState() => SchoolAppState();
}

class SchoolAppState extends State<SchoolApp> {
  bool bengali = true;
  void toggleLanguage() => setState(() => bengali = !bengali);
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Peace Valley Radiant Mission',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff16734b)), useMaterial3: true),
    home: LoginScreen(bengali: bengali, onLanguage: toggleLanguage),
  );
}
