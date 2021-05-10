import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagesView extends StatefulWidget {
  final BoxConstraints constraints;
  final bool isWeb;
  final void Function(List<String>) updateImages;

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
  List<String> images = [];
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        images.add(pickedFile.path);
        widget.updateImages(images);
      } else {
        print('No image selected.');
      }
    });
  }

  void dropImage() {
    setState(() {
      images.removeAt(_currentImage.floor() - 1);
      _imagePageController.jumpToPage(_currentImage.floor() - 1);
      widget.updateImages(images);
    });
  }

  final _imagePageController = PageController(
    viewportFraction: 0.4,
    initialPage: 1,
  );

  double _currentImage = 0.0;

  void _imageScrollLisener() {
    setState(() {
      _currentImage = _imagePageController.page;
      if (_currentImage < 1) _imagePageController.jumpToPage(1);
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
    return SizedBox(
      height: (widget.constraints.maxWidth > 800)
          ? widget.constraints.maxHeight
          : min(widget.constraints.maxWidth, widget.constraints.maxHeight),
      width: (widget.constraints.maxWidth > 800)
          ? widget.constraints.maxWidth / 2
          : widget.constraints.maxWidth,
      child: Card(
        color: Colors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        margin: EdgeInsets.all(20),
        elevation: 4.0,
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              height: 40,
              child: AutoSizeText(
                "Muestranos tu producto",
                textAlign: TextAlign.center,
                maxLines: 1,
                minFontSize: 0,
                style: TextStyle(fontSize: 25),
              ),
            ),
            Positioned(
              top: 60,
              right: 30,
              left: 30,
              bottom: 60,
              child: (images.length == 0)
                  ? IconButton(
                      icon: Icon(Icons.camera_alt_outlined),
                      onPressed: getImage,
                      iconSize: widget.constraints.maxWidth / 4,
                    )
                  : PageView.builder(
                      controller: _imagePageController,
                      itemCount: images.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) return SizedBox.shrink();
                        double val = _currentImage - index + 1;
                        double mod = -1.5 * pow(val, 2) + 3 * val + 0.5;
                        double trans = ((widget.constraints.maxWidth > 800)
                                ? widget.constraints.maxWidth
                                : widget.constraints.maxWidth * 2) /
                            11 *
                            (1 - val.clamp(0, 2));
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(2, 3, 0.002)
                            ..scale(mod.clamp(1, 2))
                            ..translate(trans),
                          child: Opacity(
                            opacity: mod.clamp(0, 1),
                            child: (widget.isWeb)
                                ? Image.network(
                                    images[index - 1],
                                    fit: BoxFit.contain,
                                  )
                                : Image.file(
                                    File(images[index - 1]),
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        );
                      },
                    ),
            ),
            Positioned(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: getImage,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_a_photo),
                          SizedBox(width: 5),
                          AutoSizeText("Agregar foto")
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(horizontal: 15)),
                    ),
                    if (images.length != 0)
                      ElevatedButton(
                        onPressed: dropImage,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.delete_forever),
                            SizedBox(width: 5),
                            AutoSizeText("Eliminar foto")
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(horizontal: 20)),
                      ),
                  ],
                ),
              ),
              bottom: 20,
              left: 20,
              right: 20,
            ),
          ],
        ),
      ),
    );
  }
}
