
import 'package:flutter/material.dart';
import 'package:innovahub_app/Auth/login/login_screen.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LogoutTextField extends StatelessWidget {
  const LogoutTextField({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
  final shouldLogout = await QuickAlert.show(
    context: context,
    type: QuickAlertType.confirm,
    title: 'Confirm Logout',
    text: 'Are you sure you want to log out?',
    //confirmBtnColor: Constant.mainColor,
    confirmBtnText: 'Logout',
    cancelBtnText: 'Cancel',
    onConfirmBtnTap: () {
      Navigator.of(context).pop(true);
    },
    onCancelBtnTap: () {
      Navigator.of(context).pop(false); 
    },
  );

  if (shouldLogout == true) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, LoginScreen.routname);
  }
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: InkWell(
        onTap: () => _confirmLogout(context),
        child: Container(
          decoration: BoxDecoration(
            color: Constant.mainColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.login_outlined, color: Constant.whiteColor),
                SizedBox(width: 8),
                Text("Log Out",
                    style: TextStyle(fontSize: 16, color: Constant.whiteColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




/*class LogoutTextField extends StatelessWidget {
  const LogoutTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Constant.mainColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const ListTile(
          title:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.login_outlined, color: Constant.whiteColor),
              SizedBox(width: 8),
          
              Text("Log Out",
              style: TextStyle(fontSize: 16, color: Constant.whiteColor)),
            ],
          ),
         
        ),
      ),
    );
  }
}*/
