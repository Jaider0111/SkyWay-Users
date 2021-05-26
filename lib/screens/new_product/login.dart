import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:skyway_users/providers/auth_provider.dart';
import 'package:skyway_users/screens/appbar.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.deepOrange,
                  Colors.deepPurple,
                ]),
          )),
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > 800.0)
              return Row(
                children: [
                  loginForm(constraints),
                  backgroundImage(constraints),
                ],
              );
            else {
              return loginForm(constraints);
            }
          }),
        ],
      ),
    );
  }

  Widget backgroundImage(BoxConstraints constraints) {
    return SizedBox(
      height: constraints.maxHeight,
      width: constraints.maxWidth / 2.0,
      child: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Image(
            image: AssetImage("assets/images/login_background.png"),
          )),
    );
  }

  Widget loginForm(BoxConstraints constraints) {
    return SizedBox(
      height: constraints.maxHeight,
      width: (constraints.maxWidth > 800.0)
          ? constraints.maxWidth / 2.0
          : constraints.maxWidth,
      child: Theme(
        data: ThemeData(fontFamily: "Itim", primaryColor: Colors.black),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 550.0,
              width: 550.0,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        "¡Bienvenido a SkyWay, el mejor lugar para comprar!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        SizedBox(width: 40),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: new BorderRadius.circular(15)),
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 15, right: 15, top: 5),
                              child: TextFormField(
                                style: TextStyle(fontSize: 20),
                                onChanged: (value) => email = value,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.person),
                                    border: InputBorder.none,
                                    fillColor: Colors.grey,
                                    focusColor: Colors.grey,
                                    focusedBorder: null,
                                    labelText: "Ingresa tu correo electrónico",
                                    labelStyle: TextStyle(fontSize: 20),
                                    contentPadding:
                                        EdgeInsets.only(bottom: 15.0)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 40)
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(children: [
                      SizedBox(width: 40),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: new BorderRadius.circular(15)),
                          child: Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: TextFormField(
                              style: TextStyle(fontSize: 20),
                              onChanged: (value) => password = value,
                              obscureText: true,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.lock),
                                  border: InputBorder.none,
                                  labelText: "Ingresa tu contraseña",
                                  labelStyle: TextStyle(fontSize: 20)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 40),
                    ]),
                    SizedBox(width: 40),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(width: 40),
                        Expanded(
                          child: FloatingActionButton.extended(
                            backgroundColor: Colors.green,
                            onPressed: () => auth(context),
                            label: Text(
                              "¡Ingresar!",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        SizedBox(width: 40)
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("¿No tienes una cuenta aún?",
                          style: TextStyle(fontSize: 15)),
                      SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            "registration",
                          );
                        },
                        child: Text("¡Regístrate aquí!",
                            style: TextStyle(fontSize: 15)),
                      ),
                    ]),
                    SizedBox(height: 20),
                    signInButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget signInButtons() {
    return Center(
      child: Column(
        children: [
          SignInButton(
            Buttons.FacebookNew,
            text: "Ingresa con Facebook",
            elevation: 8,
            onPressed: () {},
          ),
          SizedBox(height: 10),
          SignInButton(
            Buttons.Google,
            text: "Ingresa con Google",
            elevation: 8,
            onPressed: () {},
          ),
          SizedBox(height: 10),
          SignInButton(
            Buttons.GitHub,
            elevation: 8,
            text: "Ingresa con GitHub",
            onPressed: () {},
          )
        ],
      ),
    );
  }

  void auth(BuildContext context) async {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.deepOrange,
          children: [
            SpinKitCubeGrid(color: Colors.white, size: 120),
          ],
        );
      },
    );
    await Future.delayed(Duration(seconds: 3));
    final String answer =
        await BlocProvider.of<AuthProvider>(context).login(email, password);
    Navigator.of(context).pop();
    if (answer == "Tienda" || answer == "Usuario")
      Navigator.of(context).pushNamedAndRemoveUntil(
          'dashboard', (route) => false,
          arguments: {"user": answer});
    else if (answer == "incorrect email") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "La dirección de correo electrónico ingresada no se encuentra registrada"),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (answer == "failed") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("La contraseña ingresada es incorrecta"),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ha ocurrido un error de red intente nuevamente"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
