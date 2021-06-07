import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:skyway_users/screens/appbar.dart';

class DashBoard2Page extends StatefulWidget {
  DashBoard2Page({Key key}) : super(key: key);

  @override
  _DashBoard2PageState createState() => _DashBoard2PageState();
}

class _DashBoard2PageState extends State<DashBoard2Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepOrange,
                Colors.deepPurple,
              ],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Card(
                color: Colors.white38,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    sideBar(constraints),
                    bigPanel(constraints),
                  ],
                )),
          );
        }),
      ]),
    );
  }

  Widget sideBar(BoxConstraints constraints) {
    return SizedBox(
        width: constraints.maxWidth / 6.0,
        height: constraints.maxHeight,
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Colors.white70,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      width: constraints.maxWidth / 6.0 / 2.0 + 10.0,
                      height: constraints.maxWidth / 6.0 / 2.0 + 70.0,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/logoapp.png"),
                              fit: BoxFit.fill),
                        ),
                      )),
                  sideBarButton("Home", Icons.home_rounded),
                  sideBarButton("Mis ordenes", Icons.assignment_turned_in),
                  sideBarButton("Ver perfil", Icons.account_circle),
                  sideBarButton("Editar perfil", Icons.mode_edit),
                  sideBarButton("Salir", Icons.directions),
                ],
              ),
            )));
  }

  Widget bigPanel(BoxConstraints constraints) {
    return SizedBox(
        width: constraints.maxWidth / 6.0 * 4.8,
        height: constraints.maxHeight,
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            header(constraints),
            Row(
              children: [
                menuCategory(constraints),
                referAFriendWidget(constraints),
              ],
            ),
            productsView(constraints),
          ],
        )));
  }

  Widget header(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth / 6.0 * 4.8,
      height: constraints.maxHeight / 6.0,
      child: Card(
          elevation: 10.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: searchWidget(constraints)),
                Row(children: [
                  SizedBox(width: 10.0),
                  FloatingActionButton(
                    backgroundColor: Colors.white38,
                    onPressed: () {},
                    child: Image(
                      width: 40.0,
                      image: AssetImage("assets/images/bell2.png"),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  FloatingActionButton(
                    backgroundColor: Colors.white38,
                    onPressed: () {},
                    child: Image(
                      image: AssetImage("assets/images/shopping-cart.png"),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  FloatingActionButton(
                    backgroundColor: Colors.white38,
                    onPressed: () {},
                    child: Image(
                      image: AssetImage("assets/images/user.png"),
                    ),
                  ),
                ]),
              ],
            ),
          )),
    );
  }

  Widget menuCategory(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth / 6.0 * 4.8 / 2.0,
      height: constraints.maxHeight / 6.0 * 1.9,
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.white70,
        child: Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              categoryWidget(constraints, "Alimentos", "diet.png"),
              categoryWidget(constraints, "Restaurantes", "restaurant.png"),
              categoryWidget(constraints, "Farmacia", "medicine.png"),
              categoryWidget(constraints, "Otros", "settings.png"),
            ],
          ),
        ),
      ),
    );
  }

  Widget referAFriendWidget(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth / 6.0 * 4.8 / 2.0,
      height: constraints.maxHeight / 6.0 * 1.9,
      child: Card(
          elevation: 10.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: constraints.maxWidth / 6.0 * 4.8 / 2.0 / 3.0,
                  height: constraints.maxHeight / 6.0 * 1.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Refiere a un amigo y obtén \$10.000 COPS.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Itim",
                          fontSize: 24.0,
                        ),
                      ),
                      FloatingActionButton.extended(
                        backgroundColor: Colors.blue,
                        onPressed: () {},
                        label: Text(
                          "¡Referir!",
                          style: TextStyle(fontSize: 24, fontFamily: "Itim"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                SizedBox(
                    width: constraints.maxWidth / 6.0 * 4.8 / 2.0 / 2.2,
                    height: constraints.maxHeight / 6.0 * 1.9,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/stonks.jpg"),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ))
              ],
            ),
          )),
    );
  }

  Widget productsView(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth / 6.0 * 4.8,
      height: constraints.maxHeight / 6.0 * 2.75,
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.white70,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: [
            productWidget(constraints, "Hamburguesa", null, "13.000", 4.5),
          ],
        ),
      ),
    );
  }

  Widget categoryWidget(BoxConstraints constraints, name, image) {
    return Container(
      height: constraints.maxHeight / 6.0 * 1.9 - 20.0,
      width: constraints.maxHeight / 6.0 * 1.9 - 20.0,
      child: Card(
          color: Colors.white,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 70.0,
                    height: 70.0,
                    child: Image(
                      image: AssetImage("assets/images/" + image),
                    )),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Itim",
                    fontSize: 20.0,
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  mini: true,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.arrow_forward_ios_rounded),
                )
              ],
            ),
          ))),
    );
  }

  Widget searchWidget(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth / 6.0 * 4.8 / 1.5,
      height: constraints.maxHeight / 6.0 * 0.5,
      child: Theme(
        data: ThemeData(fontFamily: "Itim", primaryColor: Colors.black),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular(30.0)),
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            child: TextFormField(
              style: TextStyle(fontSize: 20),
              onChanged: (null),
              decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  border: InputBorder.none,
                  fillColor: Colors.grey,
                  focusColor: Colors.grey,
                  focusedBorder: null,
                  labelText:
                      "Ingresa el nombre del producto o restaurante que buscas ...",
                  labelStyle: TextStyle(fontSize: 20),
                  contentPadding: EdgeInsets.only(bottom: 15.0)),
            ),
          ),
        ),
      ),
    );
  }

  Widget sideBarButton(name, IconData icon) {
    return TextButton(
      onPressed: () {},
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

  Widget productWidget(BoxConstraints constraints, name, image, price, stars) {
    return Container(
      height: constraints.maxHeight / 6.0 * 1.9 - 20.0,
      width: constraints.maxHeight / 6.0 * 1.9 - 20.0,
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.white,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 140.0,
                    height: 140.0,
                    child: Image(
                      image:
                          //Se debe cargar la imagen, esperar a JaiderTutos
                          AssetImage("assets/images/hamburguesa_ejemplo.jpg"),
                    )),
                RatingBarIndicator(
                  rating: stars,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 30.0,
                  direction: Axis.horizontal,
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Itim",
                    fontSize: 20.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "\$" + price,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Itim",
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(width: 5.0),
                    FloatingActionButton(
                      onPressed: () {},
                      mini: true,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.add),
                    ),
                  ],
                )
              ],
            ),
          ))),
    );
  }
}
