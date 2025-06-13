import 'dart:io';
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class ImagePickerBuild extends StatelessWidget {
  final String label;
  final File? image;
  final VoidCallback onTap;

  const ImagePickerBuild({
    Key? key,
    required this.label,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 90,
            width: 130,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFF3F3F3),
            ),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(image!, fit: BoxFit.fill),
                  )
                : const Icon(Icons.cloud_upload_outlined,
                    size: 32, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Constant.black2Color)),
      ],
    );
  }
}
