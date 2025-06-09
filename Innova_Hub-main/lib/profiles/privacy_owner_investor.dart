import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:innovahub_app/Auth/Auth_Cubit/Auth_cubit.dart';
import 'package:innovahub_app/Auth/Auth_Cubit/Auth_states.dart';
import 'package:innovahub_app/Auth/register/register_screen.dart';
import 'package:innovahub_app/core/Api/Api_Change_password.dart';
import 'package:innovahub_app/core/Api/Api_identity_owner_investor.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/core/services/cache_services.dart';
import 'package:innovahub_app/profiles/Widgets/Imagepicker_build.dart';
import 'package:innovahub_app/profiles/Widgets/change_password_container.dart';
import 'package:innovahub_app/profiles/Widgets/delete%20_account_dialog.dart';

class PrivacyOwnerInvestor extends StatefulWidget {
  const PrivacyOwnerInvestor({super.key});

  static const String routeName = 'privacy_owner'; // routeName of this screen:
  @override
  State<PrivacyOwnerInvestor> createState() => _PrivacyOwnerInvestorState();
}

class _PrivacyOwnerInvestorState extends State<PrivacyOwnerInvestor> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  File? _frontImage;
  File? _backImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isFront) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery); // أو .camera

    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          _frontImage = File(pickedFile.path);
        } else {
          _backImage = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> handleChangePassword() async {
    final oldPassword = oldPasswordController.text;
    final newPassword = newPasswordController.text;
    final token = await CacheService.getString(key: "token");

    if (oldPassword.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    final message = await PasswordService().changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      token: token ?? "",
    );

    if (message == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password updated successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is DeleteAccountSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account deleted successfully")),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            RegisterScreen.routeName,
            (route) => false,
          );
        } else if (state is DeleteAccountErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Row(
              children: [
                SizedBox(width: 20),
                Icon(Icons.verified_user, color: Constant.mainColor, size: 25),
                SizedBox(width: 15),
                Text(
                  "Privacy & Security",
                  style: TextStyle(
                    color: Constant.blackColorDark,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                children: [
                  // Container for ID verification
                  Container(
                    padding: const EdgeInsets.only(left: 8, top: 10, right: 8),
                    height: 340,
                    width: 380,
                    decoration: BoxDecoration(
                      color: Constant.white3Color,
                      border: Border.all(width: 1, color: Constant.greyColor2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.person_pin_outlined,
                                  color: Constant.mainColor, size: 30),
                              SizedBox(width: 15),
                              Text(
                                "Identity Verification",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Constant.blackColorDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Row(
                            children: [
                              Text(
                                'You must provide a valid and clear ID images.',
                                style: TextStyle(color: Constant.greyColor4),
                              ),
                            ],
                          ),
                          const Row(
                            children: [
                              Text(
                                'Send ID Front and Back image.',
                                style: TextStyle(color: Constant.greyColor4),
                              ),
                            ],
                          ),
                          const Row(
                            children: [
                              Text(
                                'Reviewing ID may take some time.',
                                style: TextStyle(color: Constant.greyColor4),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ImagePickerBuild(
                                label: "Front ID Image",
                                image: _frontImage,
                                onTap: () => _pickImage(true),
                              ),
                              ImagePickerBuild(
                                label: "Back ID Image",
                                image: _backImage,
                                onTap: () => _pickImage(false),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_frontImage != null && _backImage != null) {
                                final uploader = IdCardUploader(
                                  frontImage: _frontImage!,
                                  backImage: _backImage!,
                                );
                                uploader.upload(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please select both images."),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Constant.mainColor,
                            ),
                            child: const Text(
                              "Send Images",
                              style: TextStyle(
                                  color: Constant.whiteColor, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// Change Password Container (مفصول في Widget)
                  ChangePasswordContainer(
                    oldPasswordController: oldPasswordController,
                    newPasswordController: newPasswordController,
                    onChangePassword: handleChangePassword,
                  ),

                  const SizedBox(height: 15),

                  /// Delete Account
                  Container(
                    padding: const EdgeInsets.only(left: 8, top: 15, right: 8),
                    height: 150,
                    width: 380,
                    decoration: BoxDecoration(
                      color: Constant.white3Color,
                      border: Border.all(width: 1, color: Constant.greyColor2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(FontAwesomeIcons.trashAlt,
                                  color: Constant.redColor),
                              SizedBox(width: 15),
                              Text(
                                "Account Deletion",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Constant.redColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => DeleteAccountDialog(
                                  onConfirm: (password) {
                                    context
                                        .read<AuthCubit>()
                                        .deleteAccount(password);
                                  },
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Constant.mainColor,
                            ),
                            child: const Text(
                              "Delete Account",
                              style: TextStyle(
                                  color: Constant.whiteColor, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
