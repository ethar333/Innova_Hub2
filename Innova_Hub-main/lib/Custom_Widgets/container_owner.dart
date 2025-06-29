
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Api/Api_Owner_home_Investment.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class InvestmentContainer extends StatelessWidget {
    final OwnerInvestment investment;
    const InvestmentContainer({super.key, required this.investment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Constant.white2Color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // First Row: Project Name, Investment Amount, Equity %
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
                  const SizedBox(height: 3),
                  Text(
                    investment.projectName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Constant.blackColorDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Profit',
                    style: TextStyle(
                      fontSize: 15,
                      color: Constant.mainColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${investment.totalProfit.toStringAsFixed(2)} EGP',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Constant.blackColorDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    '%',
                    style: TextStyle(
                      fontSize: 18,
                      color: Constant.mainColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${investment.offerDeal.toStringAsFixed(2)}%',
                    style: const TextStyle(
                        fontSize: 13,
                        color: Constant.greenColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),const SizedBox(height: 8),
          const Divider(color: Constant.greyColor4),
          const SizedBox(height: 5),

          // Second Row: Status, Duration, ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 15,
                      color: Constant.mainColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    investment.status,
                    style: TextStyle(
                      fontSize: 12,
                      color: _getStatusColor(investment.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'Duration In months',
                    style: TextStyle(
                      fontSize: 15,
                      color: Constant.mainColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${investment.durationInMonths} months',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Constant.blackColorDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'ID',
                    style: TextStyle(
                      fontSize: 15,
                      color: Constant.mainColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    investment.dealId.toString(),
                    style:const TextStyle(
                        fontSize: 13,
                        color: Constant.blackColorDark,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'adminapproved':
        return Constant.greenColor;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Constant.blackColorDark;
    }
  }
}

