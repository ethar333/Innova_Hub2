
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class ContainerOwner extends StatelessWidget {
  const ContainerOwner({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Constant.white2Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Project Name',
                          style: TextStyle(
                            fontSize: 15,
                            color: Constant.mainColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        
                        SizedBox(height: 3, ),

                        Text(
                          'Pop-one Store',
                          style: TextStyle(
                            fontSize: 12,
                            color: Constant.blackColorDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(width: 8,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Earnings',
                          style: TextStyle(
                            fontSize: 15,
                            color: Constant.mainColor,
                            fontWeight: FontWeight.w500,
                          ),
                          //textAlign: TextAlign.right,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          '152,236.33 EGP',
                          style: TextStyle(
                            fontSize: 13,
                            color: Constant.blackColorDark,
                            fontWeight: FontWeight.w500,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    //SizedBox( width: 2,),

                    Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '%',
                          style: TextStyle(
                            fontSize: 18,
                            color:
                                Constant.mainColor, // استبدل باللون الذي تريده
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          '16.56%',
                          style: TextStyle(
                              fontSize: 13,
                              color: Constant.greenColor,
                              fontWeight: FontWeight.w500),
                          //textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),

                Divider( color: Constant.greyColor4,),
                SizedBox(
                  height: 5,
                ),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total views',
                          style: TextStyle(
                            fontSize: 15,
                            color: Constant.mainColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          '27',
                          style: TextStyle(
                            fontSize: 12,
                            color: Constant.blackColorDark,
                            fontWeight: FontWeight.w500,
                          ),
                          //textAlign: TextAlign.left,
                        ),
                      ],
                    ),

                    // SizedBox(width: 12,),

                    Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Num of selling',
                          style: TextStyle(
                            fontSize: 15,
                            color: Constant.mainColor,
                            fontWeight: FontWeight.w500,
                          ),
                          //textAlign: TextAlign.center,
                        ),

                        SizedBox(   height: 3, ),

                        Text(
                          '8',
                          style: TextStyle(
                            fontSize: 13,
                            color: Constant.blackColorDark,
                            fontWeight: FontWeight.w500,
                          ),
                          //textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ID',
                          style: TextStyle(
                            fontSize: 15,
                            color: Constant.mainColor,
                            fontWeight: FontWeight.w500,
                          ),
                         // textAlign: TextAlign.center,
                        ),

                        SizedBox(   height: 3, ),
                        Text(
                          '325594',
                          style: TextStyle(
                              fontSize: 13,
                              color: Constant.blackColorDark,
                              fontWeight: FontWeight.w500),
                             // textAlign: TextAlign.center,
                        ),

                      ],

                    ),

                  ],

                ),

              ],
            ),
          );
  }
}