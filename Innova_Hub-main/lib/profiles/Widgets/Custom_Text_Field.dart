import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class CustomTextFieldPredict extends StatelessWidget {
  final String hint;
  const CustomTextFieldPredict({super.key, required this.hint,required this.controller});
   final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Constant.greyColor4,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Constant.greyColor4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Constant.greyColor4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Constant.greyColor4),
        ),
      ),
    );
  }
}

class CustomDropdownPredict extends StatefulWidget {
  final String hint;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomDropdownPredict({
    super.key,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  State<CustomDropdownPredict> createState() => _CustomDropdownPredictState();
}

class _CustomDropdownPredictState extends State<CustomDropdownPredict> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      hint: Text(
        widget.hint,
        style: const TextStyle(
          color: Constant.greyColor4,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Constant.greyColor4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Constant.greyColor4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Constant.greyColor4),
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      items: widget.items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }
}

/*class CustomDropdown extends StatefulWidget {
  const CustomDropdown({super.key});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;
  final List<String> items = [
    'Product marketing channel',
    'Affiliate',
    "Direct",
    "Email",
    "Search Engine",
    "Social Media",
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      style: const TextStyle(
        color: Constant.greyColor4,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      value: items[0],
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Constant.greyColor4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Constant.greyColor4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Constant.greyColor4),
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue;
        });
      },
    );
  }
}*/
