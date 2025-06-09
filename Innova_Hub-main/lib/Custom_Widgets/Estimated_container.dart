
import 'package:flutter/material.dart';
import 'package:innovahub_app/Models/profiles/User_profile_model.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class EstimatedContainer extends StatelessWidget {
  const EstimatedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    // Check if arguments exist and are of type UserProfile
    if (args == null || args is! UserProfile) {
      // Return some fallback UI or an empty Container
      return Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Constant.white5Color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'No user balance available yet',
            style: TextStyle(
              color: Constant.blackColorDark,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    final userProfile = args as UserProfile;

    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Constant.white5Color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
              const SizedBox(
                height: 20,
              ),
              Text(
                '${userProfile.totalBalance ?? 0}', // Provide default 0 if null
                style: const TextStyle(
                  fontSize: 24,
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















/*class EstimatedContainer extends StatelessWidget {
  const EstimatedContainer({super.key});

  
  @override
  Widget build(BuildContext context) {
    return  Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Constant.white5Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimated Balance', // text:
                      style: TextStyle(
                        color: Constant.blackColorDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' EGP', // text:
                      style: TextStyle(
                        color: Constant.purpuleColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '≈ \$0', // text:
                      style: TextStyle(
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
                  
}*/
