import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skyway_users/consts/themes.dart';
import 'package:skyway_users/providers/auth_provider.dart';
import 'package:skyway_users/screens/new_product/login.dart';
import 'package:skyway_users/screens/new_product/add_product.dart';

import 'screens/new_product/login.dart';

void main() {
  Bloc.observer = BlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthProvider>(
        create: (_) => AuthProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //final Future<FirebaseApp> _inicialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyWay',
      //routes: routes,
      //initialRoute: 'dashboard',
      theme: defaultTheme,
      home: Login1(),
      debugShowCheckedModeBanner: false,
    );
  }
}
