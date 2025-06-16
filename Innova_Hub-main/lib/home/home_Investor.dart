import 'package:flutter/material.dart';
import 'package:innovahub_app/Custom_Widgets/container_investor.dart';
import 'package:innovahub_app/Models/profiles/User_profile_model.dart';
import 'package:innovahub_app/core/Api/Api_Manager_profiles.dart';
import 'package:innovahub_app/core/Api/Api_investor_home_Investment.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/Custom_Widgets/Estimated_container.dart';

class HomeInvestor extends StatefulWidget {
  const HomeInvestor({super.key});

  @override
  State<HomeInvestor> createState() => _HomeInvestorState();
}

class _HomeInvestorState extends State<HomeInvestor> {
  late Future<List<InvestorInvestment>> futureInvestments;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureInvestments = apiService.getInvestorInvestments();
  }

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
                  child: Image.asset(
                    'assets/images/investor1.png',
                  ),
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
                              const SizedBox( width: 90,),
                              user.isVerified
                                  ? const Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 9,
                                          backgroundColor: Constant.blue3Color,
                                          child: Icon(
                                            Icons.check,
                                            color: Constant.whiteColor,
                                            size: 16,
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          'Verified',
                                          style: TextStyle(
                                            color: Constant.greyColor3,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Text(
                                      'Not Verified',
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
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
                              "ID: ${user.id}",
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
            future: futureInvestments ,
            builder: (context, snapshot) {
              // Loading State
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Constant.mainColor,
                  )),
                );
              }

              // Error State
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Error loading investments\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              // Empty State
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Padding(
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
              // Data State
              return Column(
                children: snapshot.data!
                    .map((investment) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: ContainerInvestor(investment: investment),
                        ))
                    .toList(),
              );
            },
          ),
          const SizedBox( height: 20,),
        ],
      ),
    );
  }
}
