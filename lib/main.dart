import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ran_idea_flutter/day_20/providers/favorite_provider.dart';
import 'package:ran_idea_flutter/extensions/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoriteProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAN.Idea',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Arahkan ke MainNavigation agar bottom navigation bar selalu muncul
      home: const MainNavigation(),
    );
  }
}
