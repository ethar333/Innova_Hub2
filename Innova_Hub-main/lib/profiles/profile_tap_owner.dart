import 'dart:developer';
import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:innovahub_app/core/Api/Api_Manager_profiles.dart';
import 'package:innovahub_app/Custom_Widgets/Text_Field_profile.dart';
import 'package:innovahub_app/Models/profiles/User_profile_model.dart';
import 'package:innovahub_app/core/Api/Api_Prediction_owner.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/profiles/Current_Deals_Owner.dart';
import 'package:innovahub_app/profiles/Widgets/Chart_Widget.dart';
import 'package:innovahub_app/profiles/Widgets/Custom_Text_Field.dart';
import 'package:innovahub_app/profiles/Widgets/current_products_owner.dart';
import 'package:innovahub_app/profiles/Widgets/log_out_Textfield.dart';
import 'package:innovahub_app/profiles/Widgets/textField_user.dart';
import 'package:innovahub_app/profiles/privacy_owner_investor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileOwner extends StatefulWidget {
  static String routeName = "profile_owner";
  const ProfileOwner({Key? key}) : super(key: key);

  @override
  State<ProfileOwner> createState() => _ProfileDesignState();
}

class _ProfileDesignState extends State<ProfileOwner> {
  late Future<UserProfile?> _userProfileFuture;
  File? _profileImage;
  //String? _uploadedImageUrl;
  String? _imageUrl;
  bool _isUploading = false;
  bool _isEditing = false;
  final TextEditingController adBudgetController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  final TextEditingController unitsSoldController = TextEditingController();

  String? selectedProductType;
  String? selectedSeason;
  String? selectedMarketingChannel;
  double? predictedRevenue;

  @override
  void initState() {
    super.initState();
    _userProfileFuture = ApiManagerProfiles.fetchUserProfile();

    log("user profile: ${_userProfileFuture.toString()}");
    setState(() {});
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _imageUrl = prefs.getString("profileImageUrl");
    });
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _isUploading = true;
      });

      // call upload Image function:
      String? newImageUrl =
          await ApiManagerProfiles.uploadProfileImage(_profileImage!, context);
      if (newImageUrl != null) {
        setState(() {
          _imageUrl = newImageUrl;
        });
      }

      setState(() {
        _isUploading = false;
      });
    }
  }

  // call Delete Image function:
  Future<void> _deleteProfileImage() async {
    bool isDeleted = await ApiManagerProfiles.deleteImage(context);
    if (isDeleted) {
      setState(() {
        _imageUrl = null;
        _profileImage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // const SizedBox(height: 25),
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background1.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundImage:
                            _imageUrl != null ? NetworkImage(_imageUrl!) : null,
                        backgroundColor: Colors.grey.shade300,
                        child: (_imageUrl == null)
                            ? const Icon(Icons.person,
                                size: 65, color: Constant.greyColor4)
                            : null,
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickAndUploadImage,
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Constant.mainColor,
                            child: _isUploading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Icon(
                                    Icons.camera_alt,
                                    color: Constant.whiteColor,
                                    size: 16,
                                  ),
                          ),
                        ),
                      ),

                      // delete Image Icon:
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () async {
                            await _deleteProfileImage();
                          },
                          child: const CircleAvatar(
                            radius: 13,
                            backgroundColor: Constant.mainColor,
                            child: Icon(FontAwesomeIcons.trash,
                                color: Colors.white, size: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // User Info Section:

            FutureBuilder<UserProfile>(
              future: ApiManagerProfiles.fetchUserProfile(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserProfile user = snapshot.data!; // receive data:
                  return Container(
                    width: double.infinity,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Constant.mainColor,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(100)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${user.firstName} ${user.lastName}",
                                style: const TextStyle(
                                  color: Constant.whiteColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Role:",
                                    style: TextStyle(
                                      color: Constant.whiteColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    user.roleName ?? "N/A",
                                    style: const TextStyle(
                                      color: Constant.whiteColor,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const Row(
                                children: [
                                  CircleAvatar(
                                    radius: 8,
                                    backgroundColor: Constant.whiteColor,
                                    child: Icon(
                                      Icons.check,
                                      color: Constant.blue3Color,
                                      size: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    'Verified',
                                    style: TextStyle(
                                        color: Constant.whiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w200),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Constant.mainColor,
                  ));
                }
              },
            ),

            const SizedBox(height: 13),
            FutureBuilder<UserProfile>(
              future: ApiManagerProfiles.fetchUserProfile(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserProfile user = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "ID: ${user.id} ",
                        style: const TextStyle(
                          color: Constant.greyColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ),
                    ),
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
            const Divider(
                indent: 30, endIndent: 35, color: Constant.greyColor2),
            // display user info:
            FutureBuilder<UserProfile>(
              future: ApiManagerProfiles.fetchUserProfile(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserProfile user = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: TextFieldProfile(
                                label: 'Email',
                                value: user.email ?? "N/A",
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() => _isEditing = !_isEditing);
                              },
                              icon: Icon(_isEditing ? Icons.check : Icons.edit,
                                  color: Constant.mainColor),
                              iconSize: 25,
                            ),
                          ],
                        ),
                        TextFieldProfile(
                            label: 'Phone Number',
                            value: user.phoneNumber ?? "N/A"),
                        TextFieldProfile(
                            label: 'District', value: user.district ?? "N/A"),
                        TextFieldProfile(
                            label: 'City', value: user.city ?? "N/A"),
                        const SizedBox(height: 6),
                        const Divider(
                            indent: 20,
                            endIndent: 20,
                            color: Constant.greyColor2),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Constant.mainColor,
                  ));
                }
              },
            ),

            const SizedBox(height: 15),
            const Text(
              'Keep on track and know the market\nPredict Sales',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Constant.greyColor4,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.all(10),
              //padding: EdgeInsets.all(15),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Constant.white3Color,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      //  margin: const EdgeInsets.only(left: 10, right: 10),
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      decoration: const BoxDecoration(
                        color: Constant.mainColor,
                        borderRadius: BorderRadius.only(
                          // Radius.circular(10)
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(5),
                          topLeft: Radius.circular(5),
                        ),
                      ),
                      width: double.infinity,
                      height: 60,
                      child: const Text(
                        'Predict With AI',
                        style: TextStyle(
                          color: Constant.whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Constant.greyColor4,
                        ),
                        color: const Color(0xFFEAF2FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recommendation prediction',
                              style: TextStyle(
                                color: Color(0xFF156BA3),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Get all recommendation for best products capable for selling in the season',
                              style: TextStyle(
                                color: Constant.greyColor4,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextFieldPredict(
                      hint: 'Product Ad-Budget',
                      controller: adBudgetController,
                    ),
                    const SizedBox(height: 12),
                    CustomTextFieldPredict(
                      hint: 'Product Unit Price',
                      controller: unitPriceController,
                    ),
                    const SizedBox(height: 12),
                    CustomTextFieldPredict(
                      hint: 'Product Unit Sold',
                      controller: unitsSoldController,
                    ),
                    const SizedBox(height: 12),
                    //const CustomTextFieldPredict(hint: 'Product Type'),
                    CustomDropdownPredict(
                      hint: 'Product Type',
                      items: const [
                        'HomeAndGarden',
                        'HealthAndBeauty',
                        'ToysAndGames',
                        'SportsAndFitness',
                        'BooksAndEducation',
                        'Electronics',
                        'Fashion',
                      ],
                      onChanged: (value) {
                        selectedProductType = value;
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomDropdownPredict(
                      hint: 'Product Season',
                      items: const ['Winter', 'Spring', 'Summer', 'Autumn'],
                      onChanged: (value) {
                        selectedSeason = value;
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomDropdownPredict(
                      hint: 'Product marketing channel',
                      items: const [
                        'Affiliate',
                        "Direct",
                        "Email",
                        "Search Engine",
                        "Social Media",
                      ],
                      onChanged: (value) {
                        selectedMarketingChannel = value;
                      },
                    ),
                    //const CustomDropdown(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constant.mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () async {
                          final adBudget =
                              double.tryParse(adBudgetController.text) ?? 0;
                          final unitPrice =
                              double.tryParse(unitPriceController.text) ?? 0;
                          final unitsSold =
                              int.tryParse(unitsSoldController.text) ?? 0;

                          final revenue = await PredictionService.predictSales(
                            adBudget: adBudget,
                            unitPrice: unitPrice,
                            unitsSold: unitsSold,
                            productType: selectedProductType ?? '',
                            season: selectedSeason ?? '',
                            marketingChannel: selectedMarketingChannel ?? '',
                          );

                          if (revenue != null) {
                            setState(() {
                              predictedRevenue = revenue;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Prediction failed, please try again later.'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                              color: Constant.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
             if (predictedRevenue != null)
              AnimatedRevenueWidget(revenue: predictedRevenue!),

            const Divider(
              indent: 20,
              endIndent: 20,
              color: Constant.greyColor2,
              thickness: 1,
            ),
            const SizedBox(height: 15),

            const ContainerUser(
              icon: Icons.show_chart,
              title: "Discover your Dashboard",
              route: null,
            ),
            const SizedBox(height: 15),
            const ContainerUser(
              icon: Icons.show_chart_sharp,
              title: "My Current Deals",
              route: MyCurrentDealsPage.routeName,
            ),
            const SizedBox(
              height: 15,
            ),
             const ContainerUser(
              icon: Icons.inventory_2_outlined,
              title: "My Current Products",
              route: UserProductsScreen.routname,
            ),
             const SizedBox(
              height: 15,
            ),
            const ContainerUser(
              icon: Icons.lock,
              title: "Privacy & Security",
              route: PrivacyOwnerInvestor.routeName,
            ),
            const SizedBox(height: 30),
            const LogoutTextField(),

            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
