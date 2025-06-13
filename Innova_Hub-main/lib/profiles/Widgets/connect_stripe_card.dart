
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Api/Api_connect_Stripe.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectStripeCard extends StatefulWidget {
  const ConnectStripeCard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConnectStripeCardState createState() => _ConnectStripeCardState();
}

class _ConnectStripeCardState extends State<ConnectStripeCard> {
  String? selectedPlatform;
  bool _isLoading = false;

 Future<void> _connectStripe() async {
    if (selectedPlatform == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a platform')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final url = await PaymentService.connectStripeAccount(selectedPlatform!);

    setState(() => _isLoading = false);

    if (url != null) {
      await QuickAlert.show(
        //confirmBtnColor: Constant.mainColor,
        context: context,
        type: QuickAlertType.success,
        title: 'Stripe Created',
        text: 'Your Stripe account has been created successfully!',
        confirmBtnText: 'Continue',
        onConfirmBtnTap: () async {
          Navigator.of(context).pop();  // Close the alert
          await _openUrl(url);         // Then open Stripe URL
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect Stripe account')),
      );
    }
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Stripe onboarding URL')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Constant.whiteColor,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      //elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.credit_card, size: 28, color: Color(0xFF176BA0)),
                SizedBox(width: 8),
                Text(
                  "Stripe Account",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "Connect your Stripe account",
              style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 14),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedPlatform,
                  hint: const Text("Web or Mobile", style: TextStyle(color: Colors.grey)),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: "web", child: Text("Web")),
                    DropdownMenuItem(value: "mobile", child: Text("Mobile")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedPlatform = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _connectStripe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.mainColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Send", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
