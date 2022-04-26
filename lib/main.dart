import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:frontend/mqtt/state/MQTTAppState.dart';
import 'package:frontend/screens/mqttView.dart';

import 'package:frontend/screens/screens.dart';
import 'package:frontend/services/services.dart';
import 'package:frontend/themes/custom_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TrabajadorService()),
        ChangeNotifierProvider(create: (context) => ProductService()),
        ChangeNotifierProvider(create: (context) => MQTTAppState())
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: CustomTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: const Text('Hello World'),
          ),
        ),
      ),
      initialRoute: 'home',
      routes: {
        'home': (_) => const HomeScreen(),
        'worker': (_) => const WorkerScreen(),
        'formScreen': (_) => const TrabajadorFormScreen(),
        'mqtt': (_) => const MqttViewMessages()
      },
    );
  }
}
