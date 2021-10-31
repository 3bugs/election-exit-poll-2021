import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;

  const Header({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 28.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/vote_hand.png',
                width: 100.0,
              ),
              const Text(
                'EXIT POLL',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Color(0xFFCDD6DA),
                ),
              ),
            ],
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 26.0, color: Colors.white),
        ),
      ],
    );
  }
}
