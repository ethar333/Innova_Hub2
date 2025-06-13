
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:innovahub_app/core/Api/Api_Signature_owner_investor.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';


class SignatureUploadCard extends StatefulWidget {
  const SignatureUploadCard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignatureUploadCardState createState() => _SignatureUploadCardState();
}

class _SignatureUploadCardState extends State<SignatureUploadCard> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isUploading = true;
    });

    final response = await SignatureService.uploadSignature(_image!);

    if (response != null && response.statusCode == 200) {
      print('Response: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signature uploaded successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signature upload failed')),
      );
    }

    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Constant.whiteColor,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
     // elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.draw_outlined, size: 28, color: Color(0xFF176BA0)),
                SizedBox(width: 8),
                Text("Signature", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Constant.blackColorDark)),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "Please upload a photo of your handwritten signature.",
              style: TextStyle(fontWeight: FontWeight.w400, color: Constant.blackColorDark, fontSize: 14),
            ),
            const SizedBox(height: 6),
            const Text(
              "The signature must be written by hand (not typed).\nMake sure it is clearly visible and well-lit.\nThis step is required for the investment process.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 110,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF3F3F3),
                ),
                child: Center(
                  child: _image == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload_outlined, size: 32, color: Colors.grey),
                            SizedBox(height: 6),
                            Text("Select Image", style: TextStyle(color: Colors.grey, fontSize: 16)),
                          ],
                        )
                      : Image.file(_image!, height: 100),
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _uploadImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.mainColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Upload", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
