import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innovahub_app/Auth/Auth_Cubit/Auth_cubit.dart';
import 'package:innovahub_app/Auth/Auth_Cubit/Auth_states.dart';
import 'package:innovahub_app/Auth/register/register_screen.dart';
import 'package:innovahub_app/core/Api/Api_Change_password.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/core/services/cache_services.dart';
import 'package:innovahub_app/profiles/Widgets/change_password_container.dart';
import 'package:innovahub_app/profiles/Widgets/delete%20_account_dialog.dart';

class PrivacyUser extends StatefulWidget {
  const PrivacyUser({super.key});

  static const String routeName = 'privacy_user';

  @override
  State<PrivacyUser> createState() => _PrivacyUserState();
}

class _PrivacyUserState extends State<PrivacyUser> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

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
            title: const Text(
              "Privacy & Security",
              style: TextStyle(
                color: Constant.blackColorDark,
                fontSize: 22,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ChangePasswordContainer(
                    oldPasswordController: oldPasswordController,
                    newPasswordController: newPasswordController,
                    onChangePassword: handleChangePassword,
                  ),
                  const SizedBox(height: 30),
                  // delete account:
                  Container(
                    padding: const EdgeInsets.only(left: 8, top: 25, right: 8),
                    height: 170,
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
                                    fontSize: 20, color: Constant.redColor),
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
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}






/*class PrivacyUser extends StatefulWidget {
  const PrivacyUser({super.key});

  static const String routeName = 'privacy_user';               // routeName of this screen:
  @override
  State<PrivacyUser> createState() => _PrivacyUserState();
}

class _PrivacyUserState extends State<PrivacyUser> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  
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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Privacy & Security",
            style: TextStyle(
              color: Constant.blackColorDark,
              fontSize: 22,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 8, top: 10, right: 8),
                  height: 380,
                  width: 380,
                  decoration: BoxDecoration(
                      color: Constant.white3Color,
                      border: Border.all(
                        width: 1,
                        color: Constant.greyColor2,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.password,
                              color: Constant.mainColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Change password",
                              style: TextStyle(
                                  fontSize: 20, color: Constant.blackColorDark),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'Enter your Old Password',
                          style: TextStyle(
                              color: Constant.greyColor2,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: oldPasswordController,
                          decoration: InputDecoration(
                            // hintText: "Enter your Email...",
                            hintStyle:
                                const TextStyle(color: Constant.greyColor2),
                            filled: true,
                            fillColor: Constant.whiteColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide:
                                  const BorderSide(color: Constant.greyColor2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Constant.greyColor2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Constant.greyColor2, width: 1),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          'Enter your New Password ',
                          style: TextStyle(
                              color: Constant.greyColor2,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: newPasswordController,
                          decoration: InputDecoration(
                            hintStyle:
                                const TextStyle(color: Constant.greyColor2),
                            filled: true,
                            fillColor: Constant.whiteColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide:
                                  const BorderSide(color: Constant.greyColor2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Constant.greyColor2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Constant.greyColor2, width: 1),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Constant.redColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              handleChangePassword();
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Constant.mainColor,
                            ),
                            child: const Text(
                              "Change Password",
                              style: TextStyle(
                                  color: Constant.whiteColor, fontSize: 18),
                            ))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8, top: 25, right: 8),
                  height: 170,
                  width: 380,
                  decoration: BoxDecoration(
                      color: Constant.white3Color,
                      border: Border.all(
                        width: 1,
                        color: Constant.greyColor2,
                      ),
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.trashAlt,
                              color: Constant.redColor,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Account Deletion",
                              style: TextStyle(
                                  fontSize: 20, color: Constant.redColor),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        ElevatedButton(
                            onPressed: () {

                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Constant.mainColor,
                            ),
                            child: const Text(
                              "Delete Account",
                              style: TextStyle(
                                  color: Constant.whiteColor, fontSize: 18),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}*/
