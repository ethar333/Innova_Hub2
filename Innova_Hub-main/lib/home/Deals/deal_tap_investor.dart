
import 'package:flutter/material.dart';
import 'package:innovahub_app/Custom_Widgets/deal_investor_card.dart';
import 'package:innovahub_app/Models/Deals/Business_owner_response.dart';
import 'package:innovahub_app/Models/profiles/User_profile_model.dart';
import 'package:innovahub_app/core/Api/Api_Manager_deals.dart';
import 'package:innovahub_app/core/Api/Api_Manager_profiles.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class DealInvestor extends StatefulWidget {
  const DealInvestor({super.key});

  @override
  State<DealInvestor> createState() => _DealInvestorState();
}

class _DealInvestorState extends State<DealInvestor> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: Constant.mainColor,
          ),
          //const CustomSearchBar(),

          const SizedBox( height: 15,),
           
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

         /* Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/investor1.png",
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
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 8,
                            backgroundColor: Constant.blue3Color,
                            child: Icon(
                              Icons.check,
                              color: Constant.whiteColor,
                              size: 14,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Verified',
                            style: TextStyle(
                              color: Constant.greyColor3,
                              fontSize: 13,
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
            ),
          ),*/

          const SizedBox(
            height: 20,
          ),

          const Padding(
            padding: EdgeInsets.only(left: 14),
            child: Text(
              'Recent Published Deals ',
              style: TextStyle(
                  color: Constant.blackColorDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
         
         FutureBuilder<List<BusinessOwnerResponse>>(
              future:ApiManagerDeals.getAllDeals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Constant.mainColor,));
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No deals found."));
                }

                final deals = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: deals.length,
                  itemBuilder: (context, index) {
                    return DealCardInvestor(deal: deals[index]);
                    
                  },
                );
              },
            ),
         /* Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/owner1.png',
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mohamed Ali',
                        style: TextStyle(
                          color: Constant.blackColorDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      //SizedBox(  height: 5,),

                      Text(
                        'ID:2333669591',
                        style: TextStyle(
                          color: Constant.greyColor,
                          fontSize: 15,
                        ),
                      ),

                      //SizedBox(  height: 5,),

                      Row(
                        children: [
                          CircleAvatar(
                            radius: 8,
                            backgroundColor: Constant.blue3Color,
                            child: Icon(
                              Icons.check,
                              color: Constant.whiteColor,
                              size: 14,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Verified',
                            style: TextStyle(
                              color: Constant.greyColor3,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  const Text(
                    "7:57 Am 1/23/2025",
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Text(
                  "Business Name : ",
                  style: TextStyle(
                      color: Constant.mainColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Aqua-Candels ",
                  style: TextStyle(
                      color: Constant.blackColorDark,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
           const Padding(
            padding:  EdgeInsets.only(left:20),
            child:  Row(
              children: [
                Text(
                  "Business Type : ",
                  style: TextStyle(
                      color: Constant.mainColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Home accessories",
                  style: TextStyle(
                      color: Constant.blackColorDark,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              " Description",
              style: TextStyle(
                  color: Constant.mainColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              " Lorem ipsum dolor sit amet, consectetur adipisicing elit,\n sed do eusmod tempor incididunt ut labore et dolore \n magna aliqua. Lorem ipsum dolor sit amet, consectetur \n adipisicing elit, sed doeiusmod tempor incididunt ut \n labore et dolore magna aliquaLorem ipsum dolor sit \n amet, consectetur adipisicing elit. ",
            ),
          ),

          const SizedBox(  height: 8,),

          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Text(
                  "Offer Money : ",
                  style: TextStyle(
                      color: Constant.mainColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "10,000 EGP",
                  style: TextStyle(
                      color: Constant.mainColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [

                Text("Offer Deals : ",
                  style: TextStyle(
                      color: Constant.mainColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
               
                Text("20% of total project",
                  style: TextStyle(
                      color: Constant.mainColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox( height: 10,),

          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/photo1.png',
                  width: 190,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/photo2.png',
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      'assets/images/photo3.png',
                      width: 150,
                      fit: BoxFit.cover,
                    ),

                  ],
                ),
              ],
            ),
          ),

          Row(
           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: const EdgeInsets.only(left:20,top: 15) ,
                padding: const EdgeInsets.all(12),
                //height: 40,
                 width: 190,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                    "Accept Offer",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

             // const SizedBox(  width: 20, ),

              Container(

                margin: const EdgeInsets.only(left:15,top: 15) ,
                padding: const EdgeInsets.all(12),
                width: 150,
                decoration: BoxDecoration(
                  color: Constant.yellowColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: const Center(
                        child: Text(
                      "Discuss Offer",
                      style: TextStyle(fontSize: 18, color: Constant.whiteColor),
              ))),
              ),
            ],
          ),*/
         
          const SizedBox( height : 20, ),

        ],
      ),
    );
  }

}




