import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'services/joke_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final jokeService = JokeService(prefs);

  runApp(MyApp(jokeService: jokeService));
}

class MyApp extends StatelessWidget {
  final JokeService jokeService;

  const MyApp({Key? key, required this.jokeService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Jokes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(jokeService: jokeService),
    );
  }
}