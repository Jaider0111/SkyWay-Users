import 'dart:math';

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
    return SizedBox(
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
                    onPressed: () {
                      Navigator.of(context).pushNamed('dashboard_for_buyers');
                    },
                  ),
                  NavBarButton(
                    name: "Mis ordenes",
                    icon: Icons.assignment_turned_in,
                    onPressed: () {},
                  ),
                  NavBarButton(
                    name: "Ver perfil",
                    icon: Icons.account_circle,
                    onPressed: () {
                      Navigator.of(context).pushNamed('profile');
                    },
                  ),
                  NavBarButton(
                    name: "Editar perfil",
                    icon: Icons.mode_edit,
                    onPressed: () {},
                  ),
                  NavBarButton(
                    name: "Salir",
                    icon: Icons.directions,
                    onPressed: () {
                      BlocProvider.of<AuthProvider>(context).logout();
                      Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
                    },
                  ),
                ],
              ),
            )));
  }
}

class NavBarButton extends StatelessWidget {
  final String name;
  final IconData icon;
  final void Function() onPressed;

  const NavBarButton({Key key, @required this.name, @required this.icon, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
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
                  fontSize: 22.0,
                )),
          ],
        ),
      ),
    );
  }
}
