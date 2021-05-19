import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:skyway_users/providers/auth_provider.dart';
import 'package:skyway_users/screens/appbar.dart';

void main() {
  runApp(new Login1());
}

class Login1 extends StatelessWidget {
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
          Row(
            children: [
              Container(
                width: 700,
                height: 700,
                alignment: AlignmentDirectional.center,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 625,
                      height: 650,
                      child: Theme(
                        data: ThemeData(
                            fontFamily: "Itim", primaryColor: Colors.black),
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Container(
                                width: 550,
                                height: 550,
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 30),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0),
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
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          15)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 5),
                                                child: TextFormField(
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                  onChanged: (value) =>
                                                      email = value,
                                                  decoration: InputDecoration(
                                                      icon: Icon(Icons.person),
                                                      border: InputBorder.none,
                                                      fillColor: Colors.grey,
                                                      focusColor: Colors.grey,
                                                      focusedBorder: null,
                                                      labelText:
                                                          "Ingresa tu dirección de correo electrónico",
                                                      labelStyle: TextStyle(
                                                          fontSize: 20),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 15.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 40)
                                        ],
                                        //mainAxisSize: MainAxisSize.max,
                                      ),
                                      SizedBox(height: 20),
                                      Row(children: [
                                        SizedBox(width: 40),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15)),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: TextFormField(
                                                style: TextStyle(fontSize: 20),
                                                onChanged: (value) =>
                                                    password = value,
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                    icon: Icon(Icons.lock),
                                                    border: InputBorder.none,
                                                    labelText:
                                                        "Ingresa tu contraseña",
                                                    labelStyle: TextStyle(
                                                        fontSize: 20)),
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
                                            child:
                                                FloatingActionButton.extended(
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
                                      Row(children: [
                                        SizedBox(width: 120),
                                        Text("¿No tienes una cuenta aún?",
                                            style: TextStyle(fontSize: 15)),
                                        SizedBox(width: 20),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Login2()),
                                            );
                                          },
                                          child: Text("¡Regístrate aquí!",
                                              style: TextStyle(fontSize: 15)),
                                        ),
                                        SizedBox(width: 40)
                                      ]),
                                      SizedBox(height: 20),
                                      Center(
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
                                      ),
                                    ],
                                  ),
                                  //elevation: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  child: Image(
                    image: AssetImage("assets/images/login_background.png"),
                    width: 800,
                    alignment: Alignment.topRight,
                  ),
                ),
              ),
            ],
          ),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(answer),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

//PARA REGISTRARSE:

class Login2 extends StatelessWidget {
  String email;
  String password;
  String passwordConfirmation;
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
          Row(
            children: [
              Container(
                width: 700,
                height: 770,
                alignment: AlignmentDirectional.center,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 625,
                      height: 720,
                      child: Theme(
                        data: ThemeData(
                            fontFamily: "Itim", primaryColor: Colors.black),
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Container(
                                width: 550,
                                height: 620,
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 30),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: Text(
                                          "¡Estás a punto de pertenecer a la familia SkyWay!",
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
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          15)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 5),
                                                child: TextFormField(
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                  onChanged: (value) =>
                                                      email = value,
                                                  decoration: InputDecoration(
                                                      icon: Icon(Icons.person),
                                                      border: InputBorder.none,
                                                      fillColor: Colors.grey,
                                                      focusColor: Colors.grey,
                                                      focusedBorder: null,
                                                      labelText:
                                                          "Ingresa tu dirección de correo electrónico",
                                                      labelStyle: TextStyle(
                                                          fontSize: 20),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 15.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 40)
                                        ],
                                        //mainAxisSize: MainAxisSize.max,
                                      ),
                                      SizedBox(height: 20),
                                      Row(children: [
                                        SizedBox(width: 40),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15)),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: TextFormField(
                                                style: TextStyle(fontSize: 20),
                                                onChanged: (value) =>
                                                    password = value,
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                    icon: Icon(Icons.lock),
                                                    border: InputBorder.none,
                                                    labelText:
                                                        "Ingresa tu contraseña",
                                                    labelStyle: TextStyle(
                                                        fontSize: 20)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 40.0),
                                      ]),
                                      SizedBox(height: 20.0),
                                      Row(children: [
                                        SizedBox(width: 40),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15)),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: TextFormField(
                                                style: TextStyle(fontSize: 20),
                                                onChanged: (value) =>
                                                    passwordConfirmation =
                                                        value,
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                    icon: Icon(
                                                        Icons.check_circle),
                                                    border: InputBorder.none,
                                                    labelText:
                                                        "Confirma tu contraseña",
                                                    labelStyle: TextStyle(
                                                        fontSize: 20)),
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
                                            child:
                                                FloatingActionButton.extended(
                                              backgroundColor: Colors.green,
                                              onPressed: () {},
                                              label: Text(
                                                "Ingresar",
                                                style: TextStyle(fontSize: 24),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 40)
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Row(children: [
                                        SizedBox(width: 120),
                                        Text("¿Ya tienes una cuenta?",
                                            style: TextStyle(fontSize: 15)),
                                        SizedBox(width: 20),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            // Respond to button press
                                          },
                                          child: Text("¡Ingresa aquí!",
                                              style: TextStyle(fontSize: 15)),
                                        ),
                                        SizedBox(width: 40)
                                      ]),
                                      SizedBox(height: 20),
                                      Center(
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
                                      ),
                                    ],
                                  ),
                                  //elevation: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  child: Image(
                    image: AssetImage("assets/images/login_background.png"),
                    width: 800,
                    alignment: Alignment.topRight,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void auth(BuildContext context) async {}
}
