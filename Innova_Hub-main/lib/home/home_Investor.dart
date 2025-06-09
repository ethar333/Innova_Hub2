import 'package:flutter/material.dart';
import 'package:innovahub_app/Models/profiles/User_profile_model.dart';
import 'package:innovahub_app/core/Api/Api_Manager_profiles.dart';
import 'package:innovahub_app/core/Api/Api_investor_home_.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/Custom_Widgets/Estimated_container.dart';
import 'package:innovahub_app/Custom_Widgets/container_investor.dart';

class HomeInvestor extends StatelessWidget {
  const HomeInvestor({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            color: Constant.mainColor,
          ),
          const SizedBox(
            height: 15,
          ),
         
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Constant.whiteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Constant.greyColor2,
                  child: Image.asset('assets/images/investor1.png'),
                ),
                const SizedBox(width: 10),
                FutureBuilder<UserProfile>(
                  future: ApiManagerProfiles.fetchUserProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      UserProfile user = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${user.firstName} ${user.lastName}",
                                style: const TextStyle(
                                  color: Constant.blackColorDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 130,),
                              const CircleAvatar(
                                radius: 9,
                                backgroundColor: Constant.blue3Color,
                                child: Icon(
                                  Icons.check,
                                  color: Constant.whiteColor,
                                  size: 16,
                                ),
                              ),
                             const SizedBox(
                                width: 3,
                              ),
                              const Text(
                                'Verified',
                                style: TextStyle(
                                  color: Constant.greyColor3,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          /*Text(
                            "${user.firstName} ${user.lastName}",
                            style: const TextStyle(
                              color: Constant.blackColorDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),*/
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            child: Text(
                              "ID: ${user.roleId}",
                              softWrap: true,
                              style: const TextStyle(
                                color: Constant.greyColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Constant.mainColor,
                        ),
                      );
                    }
                  },
                ),
              ], // End of children of Row
            ),
          ),

         /* Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Constant.whiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/owner1.png",
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Expanded(
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mohamed Ali',
                          style: TextStyle(
                            color: Constant.blackColorDark,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Constant.blue3Color,
                              child: Icon(
                                Icons.check,
                                color: Constant.whiteColor,
                                size: 18,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Verified',
                              style: TextStyle(
                                color: Constant.greyColor3,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID:2333669591',
                        style: TextStyle(
                          color: Constant.greyColor,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              )),*/

          const EstimatedContainer(),
          const Padding(
            padding: EdgeInsets.only(left: 14),
            child: Text(
              'Track your investments',
              style: TextStyle(
                  color: Constant.blackColorDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
          ),
          FutureBuilder<List<InvestorInvestment>>(
            future: fetchInvestorInvestments(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: Constant.mainColor,),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              }
              final investments = snapshot.data!;
              if (investments.isEmpty) {
                return  Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Icon(
                          Icons.inventory_outlined,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Investments for this investor',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You don\'t have any investments yet',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              }

              return Column(
                children: investments.map((investment) {
                  return ContainerInvestor(investment: investment);
                }).toList(),
              );
            },
          ),
         
           const SizedBox(
            height: 20,
          ), 
                   
          /*Container(
            height: 150,
            //margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Constant.whiteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Feel Free To Discover our platform Products and Deals Projects! ',
            style: TextStyle(
              color: Constant.mainColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            ),
          ),*/

        ],

      ),
    );
  }
}
