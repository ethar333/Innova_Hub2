import 'dart:developer';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/core/Api/Api_Manager_profiles.dart';
import 'package:innovahub_app/Custom_Widgets/Text_Field_profile.dart';
import 'package:innovahub_app/Models/profiles/User_profile_model.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/profiles/Widgets/log_out_Textfield.dart';
import 'package:innovahub_app/profiles/Widgets/myorder.dart';
import 'package:innovahub_app/profiles/Widgets/textField_user.dart';
import 'package:innovahub_app/profiles/privacy_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUser extends StatefulWidget {
  static String routeName = "profile_User"; // route Name of this screen:
  const ProfileUser({Key? key}) : super(key: key);

  @override
  State<ProfileUser> createState() => _ProfileDesignState();
}

class _ProfileDesignState extends State<ProfileUser> {
  late Future<UserProfile?> _userProfileFuture;
  File? _profileImage;
  //String? _uploadedImageUrl;
  String? _imageUrl;
  bool _isUploading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _userProfileFuture = ApiManagerProfiles.fetchUserProfile();

    log("user profile: ${_userProfileFuture.toString()}");
    setState(() {});
    _loadProfileImage();
  }

  // تحميل الصورة المخزنة مسبقًا من SharedPreferences
  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _imageUrl = prefs.getString("profileImageUrl");
    });
  }

  // اختيار ورفع الصورة مباشرة
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

      //await _uploadImage(); // رفع الصورة مباشرة بعد اختيارها
    }
  }

  // call Delete Image function:
  Future<void> _deleteProfileImage() async {
    bool isDeleted = await ApiManagerProfiles.deleteImage(context);
    if (isDeleted) {
      setState(() {
        _imageUrl = null;
        _profileImage = null; // إعادة تعيين المتغيرات عند الحذف
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55, // حجم الدائرة
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
                          await _deleteProfileImage(); // استدعاء الدالة مع تحديث الواجهة
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
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
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
                          Text(
                            "User ID: ${user.roleId}",
                            style: const TextStyle(
                              color: Constant.whiteColor,
                              fontWeight: FontWeight.w200,
                              fontSize: 16,
                            ),
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

            const SizedBox(height: 15),

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
            const ContainerUser(
              icon: Icons.lock,
              title: "Privacy & Security",
              route: PrivacyUser.routeName,
            ),
            const SizedBox(
              height: 15,
            ),
            const ContainerUser(
              icon: Icons.payment,
              title: "Payment Methods",
              route: null,
            ),
            const SizedBox(height: 20),
            const ContainerUser(
              icon: Icons.badge,
              title: "My Order",
              route: ReviewScreen.routeName,
            ),

            const SizedBox(height: 20),

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





/*
class ProfileUser extends StatefulWidget {
  static String routeName = "profile_User";
  const ProfileUser({Key? key}) : super(key: key);

  @override
  State<ProfileUser> createState() => _ProfileDesignState();
}

class _ProfileDesignState extends State<ProfileUser> {
  late Future<UserProfile?> _userProfileFuture;
  File? _profileImage;
  String? _uploadedImageUrl;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _userProfileFuture = ApiManagerProfiles.fetchUserProfile();
   
   log( "user profile: ${_userProfileFuture.toString()}");
    setState(() {
      
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        ApiManagerProfiles.uploadImageToServer(File(pickedFile.path));
        ApiManagerProfiles.fetchUserProfile();
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Stack(
                  children: [
                    
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _uploadedImageUrl != null
                          ? NetworkImage(_uploadedImageUrl!)
                          : (_profileImage != null ? FileImage(_profileImage!) : null) as ImageProvider?,
                      backgroundColor: Colors.grey[200],
                      child: _uploadedImageUrl == null && _profileImage == null
                          ? const Icon(Icons.person, size: 60, color: Colors.grey)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.edit, color: Constant.mainColor, size: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
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
                            icon: Icon(_isEditing ? Icons.check : Icons.edit, color: Constant.mainColor),
                            iconSize: 25,
                          ),
                        ],
                      ),

                      TextFieldProfile(label: 'Phone Number', value: user.phoneNumber ?? "N/A"),
                      TextFieldProfile(label: 'District', value: user.district ?? "N/A"),
                      TextFieldProfile(label: 'City', value: user.city ?? "N/A"),

                      const SizedBox(height: 6),
                      const Divider(indent: 20, endIndent: 20, color: Constant.greyColor2),
                    ],
                  ),
                );}else if(snapshot.hasError){
                  return Center(child: Text("Error: ${snapshot.error}"));
                }else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(height: 15),
            _buildOptionTile(Icons.lock, "Privacy & Security", PrivacyUser.routeName),
             const SizedBox(height: 15,),
            _buildOptionTile(Icons.payment, "Payment Methods", null),
            const SizedBox(height: 20),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title, String? route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Constant.mainColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(icon, color: Constant.mainColor),
          title: Text(title, style: const TextStyle(fontSize: 16, color: Constant.blackColorDark)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: route != null ? () => Navigator.pushNamed(context, route) : null,
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Constant.mainColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.login_outlined, color: Constant.whiteColor),
              SizedBox(width: 8),
              Text("Log Out", style: TextStyle(fontSize: 16, color: Constant.whiteColor)),
            ],
          ),
          onTap: () {},
        ),
      ),
    );
  }
}

*/














/*class ProfileUser extends StatefulWidget {
  static String routeName = "profile_User"; // routeName of this screen:

  final String? firstnameController;
  final String? lastnameController;
  final String? emailController;
  final String? passwordController;
  final String? cityController;
  final String? phoneNumber;
  final String? district;

  const ProfileUser({
    Key? key,
    this.firstnameController,
    this.lastnameController,
    this.emailController,
    this.passwordController,
    this.cityController,
    this.phoneNumber,
    this.district,
  }) : super(key: key);

  @override
  State<ProfileUser> createState() => _ProfileDesignState();
}

class _ProfileDesignState extends State<ProfileUser> {
  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _emailController;
  late TextEditingController _cityController;
  late TextEditingController _phoneController;
  late TextEditingController _districtController;
  late TextEditingController _roleController;

  bool _isEditing = false;
  String? userid;
  File? _profileImage; // to store selected Image:
  String? _uploadedImageUrl; // to store uploded image url:
  bool _isLoading = true;
  UserProfile? _userProfile;


  @override
  void initState() {
    super.initState();

    _firstnameController = TextEditingController(text: widget.firstnameController);
    _lastnameController = TextEditingController(text: widget.lastnameController);
    _emailController = TextEditingController(text: widget.emailController);
    _cityController = TextEditingController(text: widget.cityController);
    _phoneController = TextEditingController(text: widget.phoneNumber);
    _districtController = TextEditingController(text: widget.district);
    _roleController = TextEditingController();

    _loadProfile();

  }
  
  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    _userProfile = await ApiManagerProfiles.fetchUserProfile();
    setState(() => _isLoading = false);
  }

  
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
     // _uploadImage();
    }
  }

  
  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            // Profile Header
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _uploadedImageUrl != null
                          ? NetworkImage(
                              "$_uploadedImageUrl")
                          : (_profileImage != null
                              ? FileImage(_profileImage!)
                              : null) as ImageProvider?,
                      backgroundColor: Colors.grey[200],
                      child: _uploadedImageUrl == null && _profileImage == null
                          ? const Icon(Icons.person,
                              size: 60, color: Colors.grey)
                          : null,
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.edit,
                            color: Constant.mainColor,
                            size: 13,
                          ),
                        ),
                      ),
                    ),

                    // to delete profile Image:

                    if (_profileImage != null) // يظهر فقط عند وجود صورة
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _profileImage = null; // حذف الصورة
                            });
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Constant.mainColor,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // User Info Section
            Container(
              width: double.infinity,
              height: 70,
              decoration: const BoxDecoration(
                color: Constant.mainColor,
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(100)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${_firstnameController.text} ${_lastnameController.text}",
                      style: const TextStyle(
                        color: Constant.whiteColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "User ID: ${userid ?? 'Loading...'}",
                      style: const TextStyle(
                        color: Constant.whiteColor,
                        fontWeight: FontWeight.w200,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Profile Fields Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: TextFieldProfile(
                          controller: _emailController,
                          label: 'Email',
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = !_isEditing;
                          });
                        },
                        icon: Icon(
                          _isEditing ? Icons.check : Icons.edit,
                          color: Constant.mainColor,
                        ),
                        iconSize: 25,
                      ),
                    ],
                  ),
                  TextFieldProfile(controller: _phoneController, label: 'Phone Number'),
                  TextFieldProfile(controller: _districtController, label: 'District'),
                  TextFieldProfile(controller: _cityController, label: 'City'),
                  const SizedBox(height: 6),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                    color: Constant.greyColor2,
                    // thickness: 1,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Constant.mainColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(Icons.lock, color: Constant.mainColor),
                  title: const Text(
                    " Privacy & Security",
                    style:
                        TextStyle(fontSize: 16, color: Constant.blackColorDark),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Logic:
                    Navigator.pushNamed(context, PrivacyUser.routeName);
                  },
                ),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Constant.mainColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(Icons.payment, color: Constant.mainColor),
                  title: const Text(
                    "Payment Methods",
                    style:
                        TextStyle(fontSize: 16, color: Constant.blackColorDark),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Log out logic
                  },
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // Logout Button:

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                //color: Constant.mainColor,
                decoration: BoxDecoration(
                  color: Constant.mainColor,
                  border: Border.all(
                    color: Constant.greyColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // جعل العناصر في المنتصف
                    children: [
                      Icon(Icons.login_outlined, color: Constant.whiteColor),
                      SizedBox(width: 8), // إضافة مسافة بين الأيقونة والنص
                      Text(
                        "Log Out",
                        style:
                            TextStyle(fontSize: 16, color: Constant.whiteColor),
                      ),
                    ],
                  ),

                  //trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                  onTap: () {
                    // Log out logic
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
