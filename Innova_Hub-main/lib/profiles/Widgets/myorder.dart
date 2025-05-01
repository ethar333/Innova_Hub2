import 'package:flutter/material.dart';
import 'package:innovahub_app/home/cart_Tap.dart';
import 'package:innovahub_app/home/widget/listorder.dart';

class myorder extends StatelessWidget {
  static const String routeName = 'myorder'; // routeName of this screen:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Review",
        ),
      ),
      body: Column(
        children: [MyWidget()],
      ),
    );
  }
}
