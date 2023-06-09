import 'package:feeding_game/utils.dart';
import 'package:feeding_game/playScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'homePageProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomePageProvider>(
      create: (BuildContext context) => HomePageProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Home'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final borderRadius = BorderRadius.circular(30);

  final Gradient gradient = const LinearGradient(colors: [
    Color.fromRGBO(62, 139, 58, 1),
    Color.fromRGBO(62, 100, 50, 1),
    Color.fromRGBO(62, 80, 58, 1)
  ]);
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomePageProvider>(context);
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      primary: Colors.transparent,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
    );

    return Scaffold(
      body: provider.loading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.fromLTRB(15, 15, 15, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: _height * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text(
                            "Select animal to play with",
                            style: fontStyle(
                                context,
                                25,
                                Color.fromRGBO(62, 139, 58, 1),
                                FontWeight.w500,
                                FontStyle.normal),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: _width * 0.6,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(20.0),
                                  ),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "Select Animal",
                                fillColor: Color.fromRGBO(62, 139, 58, 0.4),
                              ),
                              isExpanded: true,
                              items: provider.animalList,
                              value: provider.selectedAnimal,
                              onChanged: (value) {
                                provider.selectAnimal(value);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: borderRadius,
                    ),
                    child: ElevatedButton(
                      style: style,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ChangeNotifierProvider<HomePageProvider>.value(
                                  value: provider,
                                  builder: (context, child) {
                                    return PlayScreen();
                                  },
                                )));
                      },
                      child: Text(
                        'Share Your Meal',
                        style: GoogleFonts.andika(
                            textStyle: Theme.of(context).textTheme.bodyText1,
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
