
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:innovahub_app/Auth/login/reset_password.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:http/http.dart' as http;


class ForgetPasswordScreen extends StatelessWidget { 
  static const String routname = "forget"; // Route name of this screen 
  final email = TextEditingController();

  ForgetPasswordScreen({super.key}); 
 
  Future<void> sendForgetPasswordRequest( 
      BuildContext context, String email) async { 
    final url = Uri.parse( 
        'https://innova-hub.premiumasp.net/api/Profile/generate-token');  
    
    try { 
      // Show loading indicator 
      showDialog( 
        context: context, 
        barrierDismissible: false, 
        builder: (BuildContext context) { 
          return const Center(child: CircularProgressIndicator()); 
        }, 
      ); 
 
      final response = await http.post( 
        url, 
        headers: {'Content-Type': 'application/json'}, 
        body: jsonEncode({'email': email}), 
      ); 
 
      // Close the loading indicator 
      Navigator.pop(context); 
 
      if (response.statusCode == 200) { 
        final responseData = jsonDecode(response.body); 
 
        if (responseData.containsKey('token') && 
            responseData.containsKey('userId')) { 
          final token = responseData['token']; 
          final userId = responseData['userId']; 
          ScaffoldMessenger.of(context).showSnackBar(SnackBar( 
            content: Text('Reset link sent successfully to $email!'), 
          )); 
          Navigator.pushNamed( 
            context, 
            resetpassword.routname, 
            arguments: { 
              'token': token, 
              'userId': userId, 
              'email': email, 
            }, 
          ); 
        } 
        else { 
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar( 
            content: Text('Invalid response from the server.'), 
          )); 
        } 
      } else { 
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar( 
          content: Text('Failed to send reset link. Please try again.'), 
        )); 
      } 
    } catch (error) { 
      Navigator.pop(context); 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar( 
        content: Text('An error occurred: $error'), 
      )); 
    } 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: const Text( 
          'Forgot Password', 
          style: TextStyle( 
            color: Colors.black, 
            fontSize: 24, 
            fontWeight: FontWeight.bold, 
          ), 
        ), 
      ), 
      body: Padding( 
        padding: const EdgeInsets.symmetric(horizontal: 15), 
        child: SingleChildScrollView( 
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center, 
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [ 
              const SizedBox(height: 30), 
              Image.asset( 
                'assets/images/forget_password_photo.jpg', 
                width: double.infinity, 
                fit: BoxFit.fill, 
              ), 
              const SizedBox(height: 30), 
              const Padding( 
                padding: EdgeInsets.only(left: 10), 
                child: Text( 
                  "Forgot Password!", 
                  style: TextStyle( 
                    color: Colors.black, 
                    fontSize: 24, 
                    fontWeight: FontWeight.bold, 
                  ), 
                ), 
              ), 
              const SizedBox(height: 10), 
              const Padding( 
                padding: EdgeInsets.only(left: 10), 
                child: Text( 
                  "Enter your email now", 
                  style: TextStyle( 
                    color: Colors.grey, 
                    fontSize: 18, 
                  ), 
                ), 
              ), 
              const SizedBox(height: 20), 
              TextField( 
                controller: email, 
                decoration: InputDecoration( 
                  labelText: 'Email',
                  hintText: 'Enter Your Email', 
                  border: OutlineInputBorder( 
                    borderRadius: BorderRadius.circular(30), 
                    borderSide: const BorderSide(
                            color: Color(0xFFB2B1B1),),
                     ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Constant.greyColor2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Constant.greyColor2),
                        ), 
                  prefixIcon: const Icon(Icons.email), 
                ), 
              ), 
              const SizedBox(height: 20), 
              SizedBox( 
                width: double.infinity, 
                child: ElevatedButton( 
                  onPressed: () { 
                    final userEmail = email.text.trim(); 
                    if (userEmail.isNotEmpty) { 
                      
                      sendForgetPasswordRequest(context, userEmail);    // 

                    }
                     else { 
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar( 
                        content: Text('Please enter your email.'), 
                      )); 
                    } 
                  }, 

                  style: ElevatedButton.styleFrom( 
                    backgroundColor: Constant.mainColor, 
                    padding: const EdgeInsets.symmetric( 
                        horizontal: 20.0, vertical: 13.0), 
                    shape: const RoundedRectangleBorder( 
                      borderRadius: BorderRadius.all(Radius.circular(20)), 
                    ), 
                  ), 
                  child: const Text( 
                    'Send', 
                    style: TextStyle( 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white, 
                      fontSize: 20, 
                    ), 
                  ), 
                ), 
              ), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
}


