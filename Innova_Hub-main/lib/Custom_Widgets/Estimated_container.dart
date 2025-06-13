
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Api/Api_Manager_profiles.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class EstimatedContainer extends StatefulWidget {
  const EstimatedContainer({super.key});

  @override
  State<EstimatedContainer> createState() => _EstimatedContainerState();
}

class _EstimatedContainerState extends State<EstimatedContainer> {
  num? totalBalance;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

Future<void> _loadProfile() async {
  try {
    final profile = await ApiManagerProfiles.fetchUserProfile();
    if (!mounted) return; 
    setState(() {
      totalBalance = profile.totalBalance ?? 0;
      isLoading = false;
    });
  } catch (e) {
    print("Error loading profile: $e");
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }
}


 @override
Widget build(BuildContext context) {
  final double exchangeRate = 50.0;        // Dollar price:
  final double totalInUSD = (totalBalance ?? 0) / exchangeRate;

  return Container(
    margin: const EdgeInsets.all(15),
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Constant.white5Color,
      borderRadius: BorderRadius.circular(12),
    ),
    child: isLoading
        ? const Center(child: CircularProgressIndicator(color: Constant.mainColor,))
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estimated Balance',
                    style: TextStyle(
                      color: Constant.blackColorDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${totalBalance?.toStringAsFixed(2)} EGP',
                    style: const TextStyle(
                      color: Constant.purpuleColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '≈ \$${totalInUSD.toStringAsFixed(2)}',  
                    style: const TextStyle(
                      color: Constant.blackColorDark,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
  );
}
}

