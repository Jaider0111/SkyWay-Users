import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:skyway_users/models/collections/product.dart';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:skyway_users/screens/appbar.dart';

void showProduct(BuildContext context, ProductModel product) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.all(0.0),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: ProductView(product: product),
      );
    },
  );
}

class ProductView extends StatelessWidget {
  const ProductView({
    Key key,
    @required this.product,
  }) : super(key: key);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final Size constraints = MediaQuery.of(context).size;
    final formatter = NumberFormat.currency(decimalDigits: 0, symbol: '', locale: 'es_CO');
    Map<String, List<String>> mapa = product.options;
    List<Widget> children = [
      SizedBox(
        width: (constraints.width > 600) ? max(300, constraints.width * 0.36) : constraints.width,
        height: (constraints.width > 600) ? max(300, constraints.width * 0.36) : constraints.width,
        child: Swiper(
          curve: Curves.bounceInOut,
          itemCount: product.images.length,
          autoplay: true,
          autoplayDelay: 3000,
          duration: 300,
          pagination: SwiperPagination(),
          itemBuilder: (context, index) {
            return FadeInImage.assetNetwork(
              placeholder: "assets/images/loader.gif",
              image: product.images[index],
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
              product.name,
              maxLines: 10,
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Itim",
                fontSize: 50.0,
              ),
            ),
            SizedBox(height: 30.0),
            RatingBarIndicator(
              rating: product.stars,
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
              "\$${formatter.format(product.price)}",
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
                  product.description,
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
                product.category,
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
                product.subcategory,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            if (product.isCountable) ...[
              Text(
                "Unidades diponibles: ${product.amount}",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Itim",
                  fontSize: 30.0,
                ),
              ),
              SizedBox(height: 30.0),
            ],
            if (product.isCustomizable) ...[
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
              for (var key in mapa.keys)
                Column(
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
                      children: [
                        for (var texts in mapa[key])
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
