import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

class ImagesView extends StatefulWidget {
  final BoxConstraints constraints;
  final bool isWeb;
  final void Function(List<Uint8List>) updateImages;

  ImagesView({
    Key key,
    @required this.isWeb,
    @required this.updateImages,
    this.constraints,
  }) : super(key: key);

  @override
  _ImagesViewState createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView> {
  List<Uint8List> images = [];
  final picker = ImagePicker();
  double _currentImage = 0.0;
  var _fileBytes;

  final _imagePageController = PageController(
    viewportFraction: 0.4,
    initialPage: 1,
  );

  void _imageScrollLisener() {
    setState(() {
      _currentImage = _imagePageController.page;
      if (_currentImage <= 1) _imagePageController.jumpToPage(1);
    });
  }

  @override
  void initState() {
    _imagePageController.addListener(_imageScrollLisener);
    super.initState();
  }

  @override
  void dispose() {
    _imagePageController.removeListener(_imageScrollLisener);
    _imagePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final constraints = widget.constraints;
    final height = (constraints.maxWidth > 800.0)
        ? constraints.maxHeight
        : min(constraints.maxWidth, constraints.maxHeight);
    final width =
        (constraints.maxWidth > 800.0) ? constraints.maxWidth / 2.0 : constraints.maxWidth;
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        child: Column(
          children: [
            SizedBox(height: 50.0),
            AutoSizeText(
              "Muestranos tu producto",
              textAlign: TextAlign.center,
              maxLines: 1,
              minFontSize: 0.0,
              style: TextStyle(fontSize: 25.0),
            ),
            SizedBox(height: 15.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: (images.length == 0)
                    ? IconButton(
                        icon: Icon(Icons.camera_alt_outlined),
                        onPressed: getImage,
                        iconSize: constraints.maxWidth / 4.8,
                      )
                    : PageView.builder(
                        controller: _imagePageController,
                        itemCount: images.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) return SizedBox.shrink();
                          double val = _currentImage - index + 1;
                          double mod = -1.5 * pow(val, 2) + 3.0 * val + 0.5;
                          double trans = ((constraints.maxWidth > 800.0)
                                  ? constraints.maxWidth
                                  : constraints.maxWidth * 2.0) /
                              11 *
                              (1 - val.clamp(0.6, 1.4)) *
                              1.2;
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(2, 3, 0.002)
                              ..translate(trans)
                              ..scale((mod / 2 * 1.6).clamp(0.8, 1.6)),
                            child: Opacity(
                              opacity: mod.clamp(0.0, 1.0),
                              child: Image.memory(
                                images[index - 1],
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
            SizedBox(height: 15.0),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: getImage,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_a_photo),
                        SizedBox(width: 5.0),
                        AutoSizeText("Agregar foto")
                      ],
                    ),
                  ),
                  if (images.length != 0)
                    ElevatedButton(
                      onPressed: dropImage,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.delete_forever),
                          SizedBox(width: 5.0),
                          AutoSizeText("Eliminar foto")
                        ],
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 50.0)
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    ImageSource x = ImageSource.gallery;
    if (!widget.isWeb)
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Selecciona la fuente de la imagen"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt_sharp),
                  color: Colors.grey,
                  iconSize: 40.0,
                  onPressed: () {
                    Navigator.of(context).pop();
                    x = ImageSource.camera;
                  },
                ),
                IconButton(
                  icon: Icon(Icons.image_rounded),
                  color: Colors.grey,
                  iconSize: 40.0,
                  onPressed: () {
                    Navigator.of(context).pop();
                    x = ImageSource.gallery;
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  x = null;
                },
                child: Text("Cancelar"),
              ),
            ],
          );
        },
      );
    if (x == null) return;
    final pickedFile = await picker.getImage(source: x);
    if (pickedFile != null) {
      _fileBytes = await pickedFile.readAsBytes();
      images.add(_fileBytes);
      widget.updateImages(images);
    } else {
      print('No image selected.');
    }
    setState(() {});
  }

  void dropImage() {
    setState(() {
      images.removeAt(_currentImage.floor() - 1);
      _imagePageController.jumpToPage(_currentImage.floor() - 1);
      widget.updateImages(images);
    });
  }
}
