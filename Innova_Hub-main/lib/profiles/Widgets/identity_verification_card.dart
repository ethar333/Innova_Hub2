import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:innovahub_app/core/Api/Api_identity_owner_investor.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/profiles/Widgets/Imagepicker_build.dart';

class IdentityVerificationCard extends StatefulWidget {
  const IdentityVerificationCard({super.key});

  @override
  State<IdentityVerificationCard> createState() => _IdentityVerificationCardState();
}

class _IdentityVerificationCardState extends State<IdentityVerificationCard> {
  File? _frontImage;
  File? _backImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isFront) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery); // أو .camera

    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          _frontImage = File(pickedFile.path);
        } else {
          _backImage = File(pickedFile.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Constant.whiteColor,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Constant.whiteColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.person_pin_outlined,
                      color: Constant.mainColor, size: 30),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Identity Verification',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Constant.blackColorDark),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'You must provide a valid and clear ID images.',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Constant.blackColorDark,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Send ID Front and Back image.',
              style: TextStyle(
                fontSize: 14,
                color: Constant.greyColor4,
              ),
            ),
            const Text(
              'Reviewing ID may take some time.',
              style: TextStyle(
                fontSize: 14,
                color: Constant.greyColor4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ImagePickerBuild(
                  label: "Front ID Image",
                  image: _frontImage,
                  onTap: () => _pickImage(true),
                ),
                ImagePickerBuild(
                  label: "Back ID Image",
                  image: _backImage,
                  onTap: () => _pickImage(false),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.mainColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  if (_frontImage != null && _backImage != null) {
                    final uploader = IdCardUploader(
                      frontImage: _frontImage!,
                      backImage: _backImage!,
                    );
                    uploader.upload(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select both images."),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Send images',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
