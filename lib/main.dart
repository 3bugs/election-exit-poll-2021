import 'package:app/pages/home_page.dart';
import 'package:app/pages/landing_page.dart';
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
      title: 'Final Exam CP SU 1/2021',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: GoogleFonts.kanit().fontFamily,
      ),
      routes: {
        LandingPage.routeName: (context) => const LandingPage(),
        HomePage.routeName: (context) => const HomePage(),
        ResultPage.routeName: (context) => const ResultPage(),
      },
      initialRoute: LandingPage.routeName,
    );
  }
}
