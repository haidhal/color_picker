// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:color_picker/view/color_picker/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreenColor extends StatefulWidget {
  const SplashScreenColor({super.key});

  @override
  State<SplashScreenColor> createState() => _SplashScreenColorState();
}

class _SplashScreenColorState extends State<SplashScreenColor> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then(
      (value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ColorPicker(),
            ));
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        color: Colors.black,
        child: Lottie.asset("assets/lottie/splashScreenLottie.json"),
      ),
    );
  }
}
