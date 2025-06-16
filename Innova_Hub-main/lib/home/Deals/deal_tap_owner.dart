
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innovahub_app/Auth/Auth_Cubit/Cubit_notification.dart';
import 'package:innovahub_app/Custom_Widgets/deal_owner_card.dart';
import 'package:innovahub_app/Models/Deals/Business_owner_response.dart';
import 'package:innovahub_app/Models/profiles/User_profile_model.dart';
import 'package:innovahub_app/core/Api/Api_Manager_deals.dart';
import 'package:innovahub_app/core/Api/Api_Manager_profiles.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/Deals/notification_page_owner.dart';
import 'package:innovahub_app/home/add_Deal_Tap_owner.dart';


class DealOwner extends StatefulWidget {
  const DealOwner({super.key});

  @override
  State<DealOwner> createState() => _DealOwnerState();
}

class _DealOwnerState extends State<DealOwner> {
  late NotificationCubit _notificationCubit;

  @override
  void initState() {
    super.initState();
    _notificationCubit = NotificationCubit();
    _notificationCubit.getUnreadNotifications(); 
  }

  @override
  void dispose() {
    _notificationCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _notificationCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 56,
                        height: 56,
                        color: Colors.black,
                        child: Image.asset(
                          'assets/images/owner1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    FutureBuilder<UserProfile>(
                      future: ApiManagerProfiles.fetchUserProfile(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final user = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${user.firstName} ${user.lastName}",
                                style: const TextStyle(
                                  color: Constant.blackColorDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 6),
                              user.isVerified
                                  ? const Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 9,
                                          backgroundColor: Constant.blue3Color,
                                          child: Icon(Icons.check,
                                              color: Constant.whiteColor,
                                              size: 16),
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
                          );
                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          return const Text("Error loading profile");
                        }
                      },
                    ),
                    const Spacer(),
                    BlocBuilder<NotificationCubit, NotificationState>(
                      builder: (context, state) {
                        int unreadCount = 0;
                        if (state is NotificationSuccessState) {
                          unreadCount = state.notificationResponse.data
                              .where((n) => !n.isRead)
                              .length;
                        }
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, notificationpage.routname);
                              },
                              child: const Icon(
                                Icons.notifications_none,
                                size: 28,
                                color: Colors.black87,
                              ),
                            ),
                            if (unreadCount > 0)
                              Positioned(
                                right: -2,
                                top: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$unreadCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Constant.white2Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, PublishDealScreen.routeName);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Publish New Deal',
                        style: TextStyle(
                          color: Constant.blackColorDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Constant.mainColor,
                            width: 3,
                          ),
                        ),
                        child: const CircleAvatar(
                          backgroundColor: Constant.whiteColor,
                          radius: 15,
                          child: Icon(
                            Icons.add,
                            color: Constant.mainColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.only(left: 14),
                child: Text(
                  'Recent Published Deals',
                  style: TextStyle(
                    color: Constant.blackColorDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<BusinessOwnerResponse>>(
                future: ApiManagerDeals.getAllDeals(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Constant.mainColor),
                    );
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
                      return DealCard(deal: deals[index]);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}







/*class DealOwner extends StatefulWidget {
  const DealOwner({super.key});

  @override
  State<DealOwner> createState() => _DealOwnerState();
}

class _DealOwnerState extends State<DealOwner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 56,
                      height: 56,
                      color: Colors.black,
                      child: Image.asset(
                        'assets/images/owner1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  FutureBuilder<UserProfile>(
                    future: ApiManagerProfiles.fetchUserProfile(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        UserProfile user = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${user.firstName} ${user.lastName}",
                                  style: const TextStyle(
                                    color: Constant.blackColorDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                            const SizedBox(height: 6),
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
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        return const Text("Error loading profile");
                      }
                    },
                  ),
                  const Spacer(),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      InkWell(
                        onTap: () {
                           Navigator.pushNamed(context, notificationpage.routname);
                        },
                        child: const Icon(Icons.notifications_none,
                        size: 28, color: Colors.black87),
                      ),
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: const Center(
                            child: Text(
                              '19',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Constant.white2Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, PublishDealScreen.routeName);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Publish New Deal              ',
                      style: TextStyle(
                        color: Constant.blackColorDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Constant.mainColor,
                          width: 3,
                        ),
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Constant.whiteColor,
                        radius: 15,
                        child: Icon(
                          Icons.add,
                          color: Constant.mainColor,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.only(left: 14),
              child: Text(
                'Recent Published Deals ',
                style: TextStyle(
                  color: Constant.blackColorDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<BusinessOwnerResponse>>(
              future: ApiManagerDeals.getAllDeals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Constant.mainColor,
                    ),
                  );
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
                    return DealCard(deal: deals[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}*/

