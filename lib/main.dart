import 'package:app/pages/home_page.dart';
import 'package:app/pages/result_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: GoogleFonts.kanit().fontFamily,
      ),
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        ResultPage.routeName: (context) => const ResultPage(),
      },
      initialRoute: HomePage.routeName,
    );
  }
}
