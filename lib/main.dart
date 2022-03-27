import 'package:flutter/material.dart';
import 'package:frontend/screens/screens.dart';
import 'package:frontend/themes/custom_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: CustomTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
      initialRoute: 'home',
      routes: {
        'home': (_) => const HomeScreen(),
        'worker': (_) => const WorkerScreen()
      },
    );
  }
}
