
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class EstimatedContainer extends StatelessWidget {
  const EstimatedContainer({super.key});

  
  @override
  Widget build(BuildContext context) {
    return  Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Constant.white5Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimated Balance', // text:
                      style: TextStyle(
                        color: Constant.blackColorDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' EGP', // text:
                      style: TextStyle(
                        color: Constant.purpuleColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '≈ \$0', // text:
                      style: TextStyle(
                        color: Constant.blackColorDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                /*Column(
                  children: [
                   /* Container(
                      //margin: EdgeInsets.only(left: 30),
                      //padding: const EdgeInsets.only(left: 10, right: 10),
                      width: 90,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Constant.blueColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Withdraw',
                          style: TextStyle(
                            color: Constant.whiteColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),*/
                    
                    const SizedBox(
                      height: 15,
                    ),
                   
                    Container(
                      //margin: EdgeInsets.only(left: 30),
                      //padding: const EdgeInsets.only(left: 10, right: 10),
                      width: 90,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Constant.blueColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Deposit',
                          style: TextStyle(
                            color: Constant.whiteColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),*/
              ],
            ),
          );


  }    
                  
}
