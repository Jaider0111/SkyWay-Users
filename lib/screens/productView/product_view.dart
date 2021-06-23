import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:skyway_users/models/collections/product.dart';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:skyway_users/providers/products_provider.dart';
import 'package:skyway_users/screens/appbar.dart';

Future showProduct(BuildContext context, ProductModel product, {bool toBuy = true}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.all(0.0),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: ProductView(product: product, toBuy: toBuy),
      );
    },
  );
}

class ProductView extends StatefulWidget {
  const ProductView({
    Key key,
    @required this.product,
    this.toBuy,
  }) : super(key: key);

  final ProductModel product;
  final bool toBuy;

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    ProductsProvider productsProvider = BlocProvider.of<ProductsProvider>(context);
    bool isInCart = productsProvider.isInCart(widget.product.id);
    final Size constraints = MediaQuery.of(context).size;
    final formatter = NumberFormat.currency(decimalDigits: 0, symbol: '', locale: 'es_CO');
    Map<String, List<String>> mapa =
        widget.product.options.map((key, value) => MapEntry(key.toString(), value.cast<String>()));
    final controller = (isInCart)
        ? TextEditingController(
            text: productsProvider.getAmountof(widget.product.id).toString(),
          )
        : null;
    List<Widget> children = [
      SizedBox(
        width: (constraints.width > 600) ? max(300, constraints.width * 0.36) : constraints.width,
        height: (constraints.width > 600) ? max(300, constraints.width * 0.36) : constraints.width,
        child: Swiper(
          curve: Curves.bounceInOut,
          itemCount: widget.product.images.length,
          autoplay: true,
          autoplayDelay: 3000,
          duration: 300,
          pagination: SwiperPagination(),
          itemBuilder: (context, index) {
            return FadeInImage.assetNetwork(
              placeholder: "assets/images/loader.gif",
              image: widget.product.images[index],
              width: (constraints.width > 600)
                  ? max(300, constraints.width * 0.35)
                  : constraints.width,
              height: (constraints.width > 600)
                  ? max(300, constraints.width * 0.35)
                  : constraints.width,
              fit: BoxFit.fitWidth,
            );
          },
        ),
      ),
      SizedBox(
        width: 20.0,
        height: 20.0,
      ),
      Expanded(
        child: ListView(
          shrinkWrap: true,
          children: [
            AutoSizeText(
              widget.product.name,
              maxLines: 10,
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Itim",
                fontSize: 50.0,
              ),
            ),
            SizedBox(height: 30.0),
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
            SizedBox(height: 30.0),
            Text(
              "\$${formatter.format(widget.product.price)}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 35.0,
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              "Descripcion",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Itim",
                fontSize: 30.0,
              ),
            ),
            const Divider(
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  widget.product.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              "Categoria",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Itim",
                fontSize: 30.0,
              ),
            ),
            const Divider(
              height: 20.0,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                widget.product.category,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              "Subcategoria",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Itim",
                fontSize: 30.0,
              ),
            ),
            const Divider(
              height: 20.0,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                widget.product.subcategory,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            if (widget.product.isCountable) ...[
              Text(
                "Unidades diponibles: ${widget.product.amount}",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Itim",
                  fontSize: 30.0,
                ),
              ),
              SizedBox(height: 30.0),
            ],
            if (widget.product.isCustomizable) ...[
              Text(
                "Caracteristicas",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Itim",
                  fontSize: 30.0,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              const Divider(
                height: 20,
                thickness: 5,
                indent: 20,
                endIndent: 20,
              ),
              for (var key in mapa.keys.cast<String>())
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 50.0,
                        ),
                        Text(
                          key,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 20,
                      thickness: 3,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var texts in mapa[key].cast<String>())
                          Row(
                            children: [
                              SizedBox(
                                width: 100.0,
                              ),
                              Text(
                                texts,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              SizedBox(height: 40.0),
            ],
            if (!widget.toBuy)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.of(context).pushNamed(
                        'addProduct',
                        arguments: {
                          'update': true,
                          'product': widget.product,
                        },
                      );
                      Navigator.of(this.context).pop();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.update),
                        SizedBox(width: 15.0),
                        Text('Actualizar Producto'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                        context: this.context,
                        builder: (context) {
                          return AlertDialog(
                            title: Column(
                              children: [
                                Text("Estás a un paso"),
                              ],
                            ),
                            content: Text(
                                "¿Deseas eliminar tu producto? Esta operacion es irreversible"),
                            actions: [
                              ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.cancel),
                                    SizedBox(width: 10),
                                    Text("Cancelar"),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        children: [
                                          SpinKitPouringHourglass(
                                            color: Colors.deepOrange,
                                            size: 150,
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  String delete =
                                      await BlocProvider.of<ProductsProvider>(this.context)
                                          .delete(widget.product.id);

                                  Navigator.of(this.context).pop();
                                  if (delete == "Eliminado exitoso") {
                                    messenger(delete, 3, this.context);
                                    Navigator.of(this.context).popAndPushNamed('profile');
                                  } else if (delete == "Eliminado erroneo")
                                    messenger(delete, 3, this.context);
                                  else
                                    messenger("Error al enviar datos", 2, this.context);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.navigate_next),
                                    SizedBox(width: 10),
                                    Text("Continuar"),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 15.0),
                        Text('Eliminar Producto'),
                      ],
                    ),
                  ),
                ],
              ),
            if (widget.toBuy) ...[
              if (isInCart)
                Row(
                  children: [
                    Text("Cantidad: " /*+ */),
                    SizedBox(
                      width: 110.0,
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            int n = -1;
                            if (widget.product.isCountable) n = widget.product.amount;
                            if (n > int.tryParse(val) || n == -1)
                              productsProvider.setAmountof(widget.product.id, int.tryParse(val));
                          });
                        },
                        controller: controller,
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                if (productsProvider.getAmountof(widget.product.id) > 1)
                                  productsProvider.deleteOneToProduct(widget.product.id);
                              });
                            },
                            icon: Icon(Icons.remove),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                int n = -1;
                                if (widget.product.isCountable) n = widget.product.amount;
                                if (n > int.tryParse((controller.text)) || n == -1)
                                  productsProvider.addOneToProduct(widget.product.id);
                              });
                            },
                            icon: Icon(Icons.add),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              if (isInCart) SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (isInCart)
                      productsProvider.removeOfCart(widget.product.id);
                    else
                      productsProvider.addToCart(widget.product, 1);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon((isInCart) ? Icons.remove : Icons.add),
                    SizedBox(width: 15.0),
                    Text((isInCart) ? 'Eliminar del carrito' : 'Agregar al carrito'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ];
    final width = (constraints.width >= 600) ? constraints.width * 0.80 : constraints.width;
    final height = (constraints.height >= 600) ? constraints.height * 0.85 : constraints.height;
    return BackgroundWidget(
      constraints: BoxConstraints.expand(height: height, width: width),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: [
            Positioned(
              bottom: 0.0,
              top: 15.0,
              left: 0.0,
              right: 0.0,
              child: (constraints.width >= 600)
                  ? Row(
                      children: children,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    )
                  : Column(
                      children: children,
                    ),
            ),
            Positioned(
              top: 10.0,
              right: 30.0,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close,
                  size: 50.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
