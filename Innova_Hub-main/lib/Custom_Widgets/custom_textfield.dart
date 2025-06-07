
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller; 
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller, 
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Constant.whiteColor,
        /*border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Constant.greyColor2),
        ),*/
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Constant.greyColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:const BorderSide(
            color: Constant.greyColor,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
    );
  }
}
