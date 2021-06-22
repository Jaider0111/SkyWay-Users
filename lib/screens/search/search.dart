import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:skyway_users/consts/themes.dart';
import 'package:skyway_users/models/collections/categories.dart';
import 'package:skyway_users/models/collections/product.dart';
import 'package:skyway_users/providers/products_provider.dart';
import 'package:skyway_users/screens/appbar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:skyway_users/screens/navigation_bar.dart';
import 'package:skyway_users/screens/productView/product_view.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    title: 'SkyWay',
    theme: defaultTheme,
    home: SearchPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<String> images = [
    'baby-beef.png',
    'FamiliarGrande.png',
    'fast-food.png',
    'farmacia.png',
    'ferreteria.png',
    'mascotas.png',
    'papeleria.png'
  ];

  String category = 'Alimentos';
  ProductsProvider _productsProvider;
  String search;
  bool isSearching = false;
  List<String> resultIds;
  List<ProductModel> products;
  Future future;

  @override
  Widget build(BuildContext context) {
    _productsProvider = BlocProvider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BackgroundWidget(
            constraints: constraints,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NavBar(width: constraints.maxWidth / 6.0, height: constraints.maxHeight),
                Expanded(
                  child: Card(
                    color: Colors.white24,
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Card(
                            margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TopBar(),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      SearchBar(
                                        onTap: (val) {
                                          setState(() {
                                            search = val;
                                            isSearching = true;
                                            resultIds = null;
                                            makeSearch();
                                          });
                                        },
                                        onChange: (val) {},
                                      ),
                                      SizedBox(height: 20.0),
                                      if (!isSearching)
                                        Expanded(
                                          child: ListView(
                                            padding: EdgeInsets.only(right: 20.0),
                                            shrinkWrap: true,
                                            children: [
                                              CategoryListViewer(
                                                category: category,
                                                onChange: (val) {
                                                  setState(() {
                                                    category = val;
                                                  });
                                                },
                                                search: (val) {
                                                  isSearching = true;
                                                  resultIds = null;
                                                  makeSearch(cat: val);
                                                },
                                              ),
                                              SizedBox(height: 10.0),
                                              SubcategoryListViewer(
                                                category: category,
                                                onTab: (val) {
                                                  isSearching = true;
                                                  resultIds = null;
                                                  makeSearch(cat: category, subcat: val);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (isSearching)
                                        Expanded(
                                          child: (resultIds != null)
                                              ? SearchResults(
                                                  resultIds: resultIds, products: products)
                                              : SpinKitWave(
                                                  size: 100.0,
                                                  itemCount: 3,
                                                  color: Colors.deepOrange,
                                                ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (constraints.maxWidth >= 800.0 && !isSearching)
                                  SizedBox(width: 10.0),
                                if (constraints.maxWidth >= 800.0 && !isSearching)
                                  Expanded(
                                    child: SearchSwiper(images: images),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void makeSearch({String cat = '', String subcat = ''}) async {
    if (cat == '' && subcat == '')
      resultIds = await _productsProvider.searchProducts(search);
    else
      resultIds = await _productsProvider.searchProductsByCatOrSubcat(cat, subcat);
    products = List.filled(resultIds.length, null);
    setState(() {});
    for (var i = 0; i < resultIds.length; i++) {
      products[i] = await _productsProvider.getProductById(resultIds[i]);
      setState(() {});
    }
  }
}

class TopBar extends StatelessWidget {
  const TopBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(Icons.location_on),
        Text(
          "Mi ubicación",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 15.0),
        Text("Calle 45 #16-84"),
        Expanded(child: SizedBox()),
        FloatingActionButton(
          heroTag: 'notification',
          backgroundColor: Colors.white38,
          onPressed: () {},
          child: Image(
            width: 40.0,
            image: AssetImage("assets/images/bell2.png"),
          ),
        ),
        SizedBox(width: 10.0),
        FloatingActionButton(
          heroTag: 'cart',
          backgroundColor: Colors.white38,
          onPressed: () {},
          child: Image(
            image: AssetImage("assets/images/shopping-cart.png"),
          ),
        ),
        SizedBox(width: 10.0),
        FloatingActionButton(
          heroTag: 'user',
          backgroundColor: Colors.white38,
          onPressed: () {},
          child: Image(
            image: AssetImage("assets/images/user.png"),
          ),
        ),
      ],
    );
  }
}

class SearchResults extends StatelessWidget {
  const SearchResults({
    Key key,
    @required this.resultIds,
    @required this.products,
  }) : super(key: key);

  final List<String> resultIds;
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: resultIds?.length,
      itemBuilder: (context, index) {
        if (products[index] == null)
          return SpinKitDoubleBounce(
            color: Colors.black87,
            size: 50.0,
          );
        final product = products[index];
        return SearchProductView(product: product, constraints: constraints);
      },
    );
  }
}

class SearchProductView extends StatefulWidget {
  const SearchProductView({
    Key key,
    @required this.product,
    @required this.constraints,
  }) : super(key: key);

  final ProductModel product;
  final Size constraints;

  @override
  _SearchProductViewState createState() => _SearchProductViewState();
}

class _SearchProductViewState extends State<SearchProductView> {
  bool favorite;

  @override
  void initState() {
    super.initState();
    favorite = false;
  }

  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(decimalDigits: 0, symbol: '', locale: 'es_CO');
    final children = [
      FadeInImage.assetNetwork(
        placeholder: "assets/images/loader.gif",
        image: widget.product.images[0],
        width: min(300, widget.constraints.width),
        height: min(300, widget.constraints.width),
        fit: BoxFit.fitWidth,
      ),
      SizedBox(
        width: 20.0,
        height: 20.0,
      ),
      Expanded(
        child: SizedBox(
          height: min(300, widget.constraints.width),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Itim",
                      fontSize: 40.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        favorite = !favorite;
                      });
                    },
                    icon: Icon(
                      (favorite) ? Icons.favorite : Icons.favorite_border,
                    ),
                    color: Colors.red,
                    iconSize: 40.0,
                  ),
                ],
              ),
              Text(
                "\$${formatter.format(widget.product.price)}",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Itim",
                  fontSize: 30.0,
                ),
              ),
              RatingBarIndicator(
                rating: widget.product.stars,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 50.0,
                direction: Axis.horizontal,
              ),
              SizedBox(
                height: 50.0,
                width: 50.0,
                child: FloatingActionButton(
                  onPressed: () {},
                  mini: true,
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.add,
                    size: 35.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ];
    return InkWell(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: (widget.constraints.width >= 600)
                ? Row(
                    children: children,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  )
                : Column(children: children),
          ),
        ),
        onTap: () {
          showProduct(context, widget.product);
        });
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
    @required this.onTap,
    @required this.onChange,
  }) : super(key: key);

  final void Function(String) onChange;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    String search;
    String error;
    return Hero(
      tag: 'searchBar',
      child: Container(
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
            topRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0),
          ),
          border: Border.all(width: 2.0, color: Colors.black26),
        ),
        child: Row(
          children: [
            SizedBox(width: 15.0),
            Expanded(
              child: TextFormField(
                autofocus: true,
                onChanged: (val) => search = val,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) =>
                    (val != null && val != '') ? null : "Ingresa el contenido de la busqueda",
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "¿Que deseas buscar?",
                  enabledBorder: InputBorder.none,
                  errorText: error,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (search != null && search != '') {
                  error = null;
                  onTap(search);
                } else
                  error = "Ingresa el contenido de la busqueda";
              },
              child: Text("Buscar"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 28.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CategoryListViewer extends StatelessWidget {
  const CategoryListViewer({
    Key key,
    @required this.category,
    @required this.onChange,
    @required this.search,
  }) : super(key: key);

  final String category;
  final void Function(String) onChange;
  final void Function(String) search;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Categorias"),
        SizedBox(
          height: 200.0,
          child: Card(
            elevation: 10,
            color: Colors.white54,
            margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 150.0,
                    width: 180.0,
                    child: Card(
                      elevation: (category == categories[index]) ? 24.0 : 6.0,
                      shadowColor:
                          (category == categories[index]) ? Colors.deepOrange[400] : Colors.black87,
                      color: (category == categories[index]) ? Colors.white : Colors.white70,
                      child: InkWell(
                        onTap: () {
                          if (category == categories[index])
                            search(category);
                          else
                            onChange(categories[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                  width: 70.0,
                                  height: 70.0,
                                  child: Image(
                                    image:
                                        AssetImage("assets/images/" + catImages[categories[index]]),
                                  )),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(categories[index]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SubcategoryListViewer extends StatelessWidget {
  const SubcategoryListViewer({
    Key key,
    @required this.category,
    @required this.onTab,
  }) : super(key: key);

  final String category;
  final void Function(String) onTab;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Subcategorias"),
        SizedBox(
          height: 200.0,
          child: Card(
            elevation: 10,
            color: Colors.white54,
            margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subcategories[category].length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 150.0,
                    width: 195.0,
                    child: Card(
                      elevation: 18,
                      color: Colors.white60,
                      child: InkWell(
                        onTap: () {
                          onTab(subcategories[category][index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                  width: 70.0,
                                  height: 70.0,
                                  child: Image(
                                    image: NetworkImage(catImages[subcategories[category][index]]),
                                  )),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(subcategories[category][index]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchSwiper extends StatelessWidget {
  const SearchSwiper({
    Key key,
    @required this.images,
  }) : super(key: key);

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Swiper(
      curve: Curves.elasticOut,
      itemCount: images.length,
      autoplay: true,
      autoplayDelay: 3000,
      duration: 300,
      itemBuilder: (context, index) {
        return Image.asset(
          'assets/images/${images[index]}',
          fit: BoxFit.contain,
        );
      },
    );
  }
}
