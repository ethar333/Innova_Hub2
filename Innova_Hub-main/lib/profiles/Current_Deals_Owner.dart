import 'package:flutter/material.dart';
import 'package:innovahub_app/Models/Deals/Deal_Business_Owner_model.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/profiles/Widgets/Deal_Card_Container.dart';
import '../core/Api/Api_GetAll_Deals_Owner.dart';

class MyCurrentDealsPage extends StatefulWidget {
  const MyCurrentDealsPage({Key? key}) : super(key: key);

  static const String routeName = "Deal_owner";

  @override
  State<MyCurrentDealsPage> createState() => _MyCurrentDealsPageState();
}

class _MyCurrentDealsPageState extends State<MyCurrentDealsPage> {
  void showTerminationDialog(BuildContext context, int dealId) {
    String selectedReason = 'Completed';
    TextEditingController notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Terminate Deal"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedReason,
                onChanged: (value) {
                  if (value != null) selectedReason = value;
                },
                items: [
                  'Completed',
                  'OwnerTerminated',
                  'InvestorTerminated',
                  'AdminTerminated',
                  'Bankruptcy',
                  'MutualAgreement',
                  'Breach',
                  'Other'
                ].map((reason) {
                  return DropdownMenuItem(
                    value: reason,
                    child: Text(reason),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'End Reason'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Termination Notes',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Confirm"),
              onPressed: () async {
                print("Confirm clicked");
                await ApiManagerDealsOwner.terminateDeal(
                    dealId, selectedReason, notesController.text, context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constant.whiteColor,
        appBar: AppBar(
          backgroundColor: Constant.whiteColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Row(
            children: [
              Icon(Icons.show_chart, color: Constant.mainColor, size: 30),
              SizedBox(width: 8),
              Text(
                'My Current Deals',
                style: TextStyle(
                  color: Constant.blackColorDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder<List<DealBusinessOwner>?>(
          future: ApiManagerDealsOwner.getAllDealsForOwner(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Constant.mainColor));
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No deals found"));
            }

            final deals = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: deals.length,
              itemBuilder: (context, index) {
                final deal = deals[index];
                return Column(
                  children: [
                    DealCardContainer(
                      title: deal.businessName,
                      status: deal.isApproved ? "Approved" : "Pending",
                      statusColor:
                          deal.isApproved ? Colors.green : Colors.orange,
                      description: deal.description,
                      categories: [
                        chip("Category: ${deal.categoryName}",
                            Constant.blue4Color),
                        chip("Money: ${deal.offerMoney} EGP",
                            Constant.greyColor4),
                        chip("Offer: ${deal.offerDeal}%", Constant.green2Color),
                      ],
                      prices: [
                        {
                          'label': 'Estimated Price:',
                          'value': '${deal.estimatedPrice} EGP'
                        },
                        {
                          'label': 'Manufacturing Cost:',
                          'value': '${deal.manufacturingCost} EGP'
                        },
                      ],
                      images: deal.pictures,
                      onDelete: () {
                        showTerminationDialog(context, deal.dealId);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            );
          },
        ));
  }

  Widget chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/profiles/Widgets/Deal_Card_widget.dart';

class MyCurrentDealsPage extends StatelessWidget {
  const MyCurrentDealsPage({Key? key}) : super(key: key);
  
    static const String routeName = "Deal_owner";              // route name:

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.whiteColor,
      appBar: AppBar(
        backgroundColor: Constant.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Row(
          children: [
            Icon(Icons.show_chart, color:Constant.mainColor,size: 30, ),
            SizedBox(width: 8),
            Center(
              child: Text(
                'My Current Deals',
                style: TextStyle(color: Constant.blackColorDark, fontWeight: FontWeight.bold,fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DealCardContainer(
            title: 'Aqua-Candels',
            status: 'Approved',
            statusColor: Constant.green3Color,
            description:
                'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliquaLorem.',
            categories: [
              chip('Category: Home accessories', Constant.blue4Color),
              chip('Money: 10000EGP', Constant.greyColor4),
              chip('Offer: 35%', Constant.green2Color),
            ],
            prices: [
              {'label': 'Estimated Price:', 'value': '400 EGP'},
              {'label': 'Manufacturing Cost:', 'value': '200 EGP'},
            ],
            images: [
              'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
              'https://images.unsplash.com/photo-1519125323398-675f0ddb6308',
              'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
              'https://images.unsplash.com/photo-1502082553048-f009c37129b9',
            ],
            onDelete: () {},
          ),
          const SizedBox(height: 16),
        
        /*  _dealCard(
            title: 'ART-DRAWING',
            status: 'Pending',
            statusColor: Colors.orange,
            description:
                'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliquaLorem.',
            categories: [],
            prices: [],
            images: [],
            onDelete: () {},
            pending: true,
          ),*/
        ],
      ),
    );
  }

  Widget chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }
}*/
