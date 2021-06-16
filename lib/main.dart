import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skyway_users/providers/auth_provider.dart';
import 'package:skyway_users/providers/products_provider.dart';
import 'consts/routes.dart';
import 'consts/themes.dart';

void main() {
  Bloc.observer = BlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ProductsProvider>(
        create: (_) => ProductsProvider(),
      ),
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
  final Future<FirebaseApp> _inicialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _inicialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) return ErrorWidget(snapshot.error);
        if (snapshot.connectionState == ConnectionState.done)
          return MaterialApp(
            title: 'SkyWay',
            routes: routes,
            initialRoute: 'checkout',
            theme: defaultTheme,
            debugShowCheckedModeBanner: false,
          );
        return ErrorWidget("Espera");
      },
    );
  }
}
