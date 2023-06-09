import 'package:extended_image/extended_image.dart';
import 'package:feeding_game/success.dart';
import 'package:feeding_game/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'homePageProvider.dart';

class PlayScreen extends StatefulWidget {
  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final borderRadius = BorderRadius.circular(50);
  final Gradient gradient = const LinearGradient(colors: [
    Color.fromRGBO(62, 139, 58, 1),
    Color.fromRGBO(62, 100, 50, 1),
    Color.fromRGBO(62, 80, 58, 1)
  ]);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    final provider = Provider.of<HomePageProvider>(context);
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      primary: Colors.transparent,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
    );

    void _uploadedFile() {
      provider.chooseFile();
    }

    Future<void> _submit(animal) async {
      await provider.submit(animal);
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: _width * 0.18,
              height: _height * 0.08,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: borderRadius,
              ),
              child: Center(
                child: ElevatedButton(
                    style: style,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 35,
                    )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SafeArea(
              child: SizedBox(
                width: _width,
                height: _height * 0.3,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/${provider.selectedAnimal}.svg',
                    height: 80 * provider.animalSize,
                    width: 80 * provider.animalSize,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: _width,
              height: _height * 0.3,
              child: Center(
                child: CustomPaint(
                  foregroundPainter: BorderPainter(),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: provider.mediaLink != ""
                        ? NetworkImage(provider.mediaLink)
                        : null,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ),
            provider.isImageUploading
                ? Container(
                    child: LinearProgressIndicator(),
                    height: 4.0,
                  )
                : Container(),
            SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      provider.mediaLink == ''
                          ? "Click Your Meal"
                          : "Will you eat this?",
                      style: fontStyle(context, 20, Colors.black,
                          FontWeight.w400, FontStyle.normal),
                    ),
                  ),
                  SizedBox(height: 10),
                  provider.mediaLink == ''
                      ? Container(
                          width: _width * 0.18,
                          height: _height * 0.08,
                          decoration: BoxDecoration(
                            gradient: gradient,
                            borderRadius: borderRadius,
                          ),
                          child: Center(
                            child: ElevatedButton(
                                style: style,
                                onPressed: () {
                                  _uploadedFile();
                                },
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 35,
                                )),
                          ),
                        )
                      : Container(
                          width: _width * 0.18,
                          height: _height * 0.08,
                          decoration: BoxDecoration(
                            gradient: gradient,
                            borderRadius: borderRadius,
                          ),
                          child: Center(
                            child: ElevatedButton(
                                style: style,
                                onPressed: () async {
                                  await _submit(provider.selectedAnimal);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => GoodJob()));
                                },
                                child: Icon(
                                  Icons.check,
                                  size: 35,
                                )),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = sh * 0.1; // desirable value for corners side

    Paint paint = Paint()
      ..color = Color.fromRGBO(62, 139, 58, 1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    Path path = Path()
      ..moveTo(cornerSide, 0)
      ..quadraticBezierTo(0, 0, 0, cornerSide)
      ..moveTo(0, sh - cornerSide)
      ..quadraticBezierTo(0, sh, cornerSide, sh)
      ..moveTo(sw - cornerSide, sh)
      ..quadraticBezierTo(sw, sh, sw, sh - cornerSide)
      ..moveTo(sw, cornerSide)
      ..quadraticBezierTo(sw, 0, sw - cornerSide, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
