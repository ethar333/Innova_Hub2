
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Api/Api_investor_home_Investment.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class ContainerInvestor extends StatelessWidget {
   const ContainerInvestor({super.key,required this.investment});

    final InvestorInvestment investment;    // object from model:

  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Constant.white2Color,
        borderRadius: BorderRadius.circular(12),
      ),
      child:  Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Project Name',
                    style: TextStyle(
                      fontSize: 15,
                      color: Constant.mainColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox( height: 3, ),
                  Text(
                    investment.projectName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Constant.blackColorDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // SizedBox(width: 8,),
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Profit',
                      style: TextStyle(
                        fontSize: 15,
                        color: Constant.mainColor,
                        fontWeight: FontWeight.w500,
                      ),
                      //textAlign: TextAlign.right,
                    ),
                    const SizedBox( height: 3,),
                    Text(
                       '${investment.totalProfit.toStringAsFixed(2)} EGP',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Constant.blackColorDark,
                        fontWeight: FontWeight.w500,
                      ),
                      //textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '%',
                    style: TextStyle(
                      fontSize: 18,
                      color: Constant.mainColor, // استبدل باللون الذي تريده
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(  height: 3, ),
                  Text(
                  '${investment.offerDeal.toStringAsFixed(2)}%',
                    style: const TextStyle(
                        fontSize: 13,
                        color: Constant.greenColor,
                        fontWeight: FontWeight.w500),
                    //textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox( height: 8,),
          const Divider( color: Constant.greyColor4,),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deal Value',
                    style: TextStyle(
                      fontSize: 15,
                      color: Constant.mainColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3,),
                  Text(
                   '${investment.offerMoney.toStringAsFixed(2)} EGP',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Constant.blackColorDark,
                      fontWeight: FontWeight.w500,
                    ),
                    //textAlign: TextAlign.left,
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Owner Name',
                      style: TextStyle(
                        fontSize: 15,
                        color: Constant.mainColor,
                        fontWeight: FontWeight.w500,
                      ),
                      //textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 3,),
                    Text(
                      investment.ownerName,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Constant.blackColorDark,
                        fontWeight: FontWeight.w500,
                      ),
                      //textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
             const SizedBox(width: 5,),
              const Padding(
                padding: EdgeInsets.only(
                  right: 10,
                ),
                child: Icon(
                  Icons.email_outlined,
                  color: Constant.mainColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

