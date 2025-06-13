
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innovahub_app/Auth/Auth_Cubit/Auth_cubit.dart';
import 'package:innovahub_app/Auth/Auth_Cubit/Auth_states.dart';
import 'package:innovahub_app/Auth/register/register_screen.dart';
import 'package:innovahub_app/core/Api/Api_Change_password.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/core/services/cache_services.dart';
import 'package:innovahub_app/profiles/Widgets/Delete_account_card.dart';
import 'package:innovahub_app/profiles/Widgets/Signature_card.dart';
import 'package:innovahub_app/profiles/Widgets/change_password_card.dart';
import 'package:innovahub_app/profiles/Widgets/connect_stripe_card.dart';
import 'package:innovahub_app/profiles/Widgets/identity_verification_card.dart';

class PrivacyOwnerInvestor extends StatefulWidget {
  const PrivacyOwnerInvestor({super.key});

  static const String routeName = 'privacy_owner'; // routeName of this screen:
  @override
  State<PrivacyOwnerInvestor> createState() => _PrivacyOwnerInvestorState();
}

class _PrivacyOwnerInvestorState extends State<PrivacyOwnerInvestor> {
  String? selectedPlatform;
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
          backgroundColor: Constant.whiteColor,
          appBar: AppBar(
            backgroundColor: Constant.whiteColor,
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
                  const IdentityVerificationCard(),
                  const SizedBox(height: 15),
                  const SignatureUploadCard(),
                  const SizedBox(
                    height: 15,
                  ),
                  // Stripe Account Card
                  const ConnectStripeCard(),
                  const SizedBox(height: 15),
                  // Change Password Container:
                  ChangePasswordCard(
                    oldPasswordController: oldPasswordController,
                    newPasswordController: newPasswordController,
                    onChangePassword: handleChangePassword,
                  ),

                  const SizedBox(height: 15),

                  /// Delete Account
                  const DeleteAccountCard(),
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
