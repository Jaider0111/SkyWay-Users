import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

void main() {
  runApp(new Login());
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: 600,
                alignment: AlignmentDirectional.center,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 600,
                      height: 590,
                      child: Theme(
                        data: ThemeData(
                            fontFamily: "Itim", primaryColor: Colors.black),
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            children: [
                              SizedBox(height: 50),
                              Container(
                                width: 600,
                                height: 490,
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 30),
                                      Container(
                                        child: Text(
                                          "¡Bienvenido a SkyWay, el mejor lugar para comprar!",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      Row(
                                        children: [
                                          SizedBox(width: 40),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          15)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 5),
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                      icon: Icon(Icons.person),
                                                      border: InputBorder.none,
                                                      fillColor: Colors.grey,
                                                      focusColor: Colors.grey,
                                                      focusedBorder: null,
                                                      labelText:
                                                          "Ingresa tu nombre de usuario"),
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
                                                color: Colors.grey,
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15)),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: TextFormField(
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                    icon: Icon(Icons.lock),
                                                    border: InputBorder.none,
                                                    labelText:
                                                        "Ingresa tu contraseña"),
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
                                        Text("¿No tienes una cuenta aún?"),
                                        SizedBox(width: 20),
                                        TextButton(
                                          onPressed: () {
                                            // Respond to button press
                                          },
                                          child: Text("¡Regístrate aquí!"),
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
                                            SizedBox(height: 5),
                                            SignInButton(
                                              Buttons.Google,
                                              text: "Ingresa con Google",
                                              elevation: 8,
                                              onPressed: () {},
                                            ),
                                            SizedBox(height: 5),
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
              Container(
                child: Image(
                  image: AssetImage("images/login2.png"),
                  width: 800,
                  alignment: Alignment.topRight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
