import 'package:emergency/firebase/firebase_options.dart';
import 'package:emergency/store/providers.dart';
import 'package:emergency/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Emergency app",
        initialRoute: '/start_page',
        routes: appRoutes,
      ),
    );
  }
}
