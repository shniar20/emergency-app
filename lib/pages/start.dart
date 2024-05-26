import 'package:emergency/store/user_provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    Timer(const Duration(milliseconds: 500), () {
      _controller.forward();

      Timer(const Duration(seconds: 2), () {
        userProvider.isSignedIn
            ? Navigator.pushReplacementNamed(context, '/navigation')
            : Navigator.pushReplacementNamed(context, '/registration');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _animation,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/team.jpg"),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 450.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 8),
                    Text(
                      'فریاگوزاری',
                      style: TextStyle(
                        fontFamily: 'rabar',
                        color: Color.fromARGB(255, 33, 67, 127),
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
