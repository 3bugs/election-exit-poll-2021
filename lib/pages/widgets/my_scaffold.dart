import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  final Widget child;

  const MyScaffold({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: child,
        ),
      ),
    );
  }
}
