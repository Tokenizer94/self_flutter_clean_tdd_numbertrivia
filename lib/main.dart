import 'package:flutter/material.dart';
import 'package:self_tdd_clean_fresh/features/number_trivia/presentation/pages/number_trivia_page.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.green[600],
      ),
      home: NumberTriviaPage(),
    );
  }
}


