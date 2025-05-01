import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            MyWidget(),
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Constant.whiteColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 130,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Constant.whiteColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Constant.greyColor4),
                      ),
                      child: const Text(
                        "What Should Other Custom Know !",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Constant.greyColor4,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.mainColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  minimumSize: const Size(220, 50),
                ),
                child: const Text('Submit',
                    style: TextStyle(fontSize: 18, color: Constant.whiteColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
