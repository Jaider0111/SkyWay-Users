import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skyway_users/consts/themes.dart';
import 'package:skyway_users/providers/auth_provider.dart';
import 'package:skyway_users/screens/appbar.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    title: 'SkyWay',
    theme: defaultTheme,
    home: Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return BackgroundWidget(
          constraints: constraints,
          child: Row(
            children: [
              NavBar(
                width: constraints.maxWidth / 6.0,
                height: constraints.maxHeight,
              ),
            ],
          ),
        );
      }),
    ),
  ));
}

class NavBar extends StatelessWidget {
  const NavBar({
    Key key,
    @required this.width,
    @required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final _authProvider = BlocProvider.of<AuthProvider>(context);
    return Hero(
      tag: 'navbar',
      child: SizedBox(
          width: width,
          height: height,
          child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              color: Colors.white70,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        width: width / 2.0 + 10.0,
                        height: width / 2.0 + 70.0,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/logoapp.png"), fit: BoxFit.fill),
                          ),
                        )),
                    NavBarButton(
                      name: "Home",
                      icon: Icons.home_rounded,
                      route:
                          (_authProvider.status == 'Tienda') ? 'dashboard' : "dashboard_for_buyers",
                    ),
                    NavBarButton(
                      name: "Mis ordenes",
                      icon: Icons.assignment_turned_in,
                      route: 'orders',
                    ),
                    NavBarButton(
                      name: "Ver perfil",
                      icon: Icons.account_circle,
                      route: "profile",
                    ),
                    NavBarButton(
                      name: "Editar perfil",
                      icon: Icons.mode_edit,
                      route: null,
                    ),
                    NavBarButton(
                      name: "Salir",
                      icon: Icons.directions,
                      route: "login",
                    ),
                  ],
                ),
              ))),
    );
  }
}

class NavBarButton extends StatelessWidget {
  final String name;
  final IconData icon;
  final String route;

  const NavBarButton({Key key, @required this.name, @required this.icon, @required this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (route == "login") {
          BlocProvider.of<AuthProvider>(context).logout();
          Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
        } else {
          Navigator.of(context).pushNamed(route);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.black),
            SizedBox(width: 5.0),
            Text(name,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Itim",
                  fontSize: 24.0,
                )),
          ],
        ),
      ),
    );
  }
}
