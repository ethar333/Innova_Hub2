import 'package:flutter/material.dart';
import 'package:innovahub_app/Models/profiles/User_profile_model.dart';
import 'package:innovahub_app/Products/product_page.dart';
import 'package:innovahub_app/core/Api/Api_Manager_categories.dart';
import 'package:innovahub_app/core/Api/Api_Manager_profiles.dart';
import 'package:innovahub_app/core/Api/Api_Owner_home_Investment.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/Custom_Widgets/Estimated_container.dart';
import 'package:innovahub_app/Custom_Widgets/Stack_listCart.dart';
import 'package:innovahub_app/Custom_Widgets/category_card.dart';
import 'package:innovahub_app/Custom_Widgets/container_owner.dart';
import 'package:innovahub_app/Custom_Widgets/stack_listHandmade.dart';
import 'package:innovahub_app/Models/Category_response.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/home/Deals/owner_product.dart';
import 'package:innovahub_app/home/widget/Custom_Deal_button.dart';
import 'package:innovahub_app/home/widget/recommended_product_list.dart';

class HomeOwner extends StatefulWidget {
  const HomeOwner({super.key});

  @override
  State<HomeOwner> createState() => _HomeOwnerState();
}

class _HomeOwnerState extends State<HomeOwner> {
  late Future<List<OwnerInvestment>> futureInvestments;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureInvestments = apiService.getOwnerInvestments();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: Constant.mainColor,
          ),
          const SizedBox(height: 15),

          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Constant.whiteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Constant.greyColor2,
                  child: Image.asset('assets/images/owner1.png'),
                ),
                const SizedBox(width: 10),
                FutureBuilder<UserProfile>(
                  future: ApiManagerProfiles.fetchUserProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      UserProfile user = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${user.firstName} ${user.lastName}",
                                style: const TextStyle(
                                  color: Constant.blackColorDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 90,
                              ),
                              user.isVerified
                                  ? const Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 9,
                                          backgroundColor: Constant.blue3Color,
                                          child: Icon(
                                            Icons.check,
                                            color: Constant.whiteColor,
                                            size: 16,
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          'Verified',
                                          style: TextStyle(
                                            color: Constant.greyColor3,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Text(
                                      'Not Verified',
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ],
                          ),
                          /*Text(
                            "${user.firstName} ${user.lastName}",
                            style: const TextStyle(
                              color: Constant.blackColorDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),*/
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            child: Text(
                              "ID: ${user.id}",
                              softWrap: true,
                              style: const TextStyle(
                                color: Constant.greyColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Constant.mainColor,
                        ),
                      );
                    }
                  },
                ),
              ], // End of children of Row
            ),
          ),

          const EstimatedContainer(),

          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Constant.white2Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, OwnerPublish.routeName);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Constant.mainColor,
                        width: 3,
                      ),
                    ),
                    child: const CircleAvatar(
                      backgroundColor: Constant.whiteColor,
                      radius: 15,
                      child: Icon(
                        Icons.add,
                        color: Constant.mainColor,
                        size: 30,
                      ),
                    ),
                  ),
                ), // Icon:

                const Text(
                  'Publish New Product             ', // text:
                  style: TextStyle(
                    color: Constant.blackColorDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              'Latest product overview', // text:
              style: TextStyle(
                color: Constant.blackColorDark,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // const SizedBox(height: 10,),
          FutureBuilder<List<OwnerInvestment>>(
            future: futureInvestments,
            builder: (context, snapshot) {
              // Loading State
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Constant.mainColor,
                  )),
                );
              }

              // Error State
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Error loading investments\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              // Empty State
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Icon(
                          Icons.inventory_outlined,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Owner Investment',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You don\'t have any investments yet',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              }

              // Data State
              return Column(
                children: snapshot.data!
                    .map((investment) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            //vertical: 4,
                          ),
                          child: InvestmentContainer(investment: investment),
                        ))
                    .toList(),
              );
            },
          ),
          const SizedBox(
            height: 15,
          ),
          const Center(
            child: Text(
              'You Can start ur investment Easily',
              style: TextStyle(
                  fontSize: 16,
                  color: Constant.black3Color,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                side: const BorderSide(color: Color(0xFFE0E0E0)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.white,
              ),
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Custom bar chart icon
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CustomPaint(
                      painter: BarChartPainter(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Go Deals Now',
                    style: TextStyle(
                      color: Constant.blue3Color,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /*  Container(
            decoration: const BoxDecoration(
              color: Constant.mainColor,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(60),
                  topLeft: Radius.circular(60)),
            ),
            width: double.infinity,
            height: 105,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'You Can start ur investment Easily',
                      style: TextStyle(
                          fontSize: 14,
                          color: Constant.whiteColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Go Deals Now',
                      style: TextStyle(
                        fontSize: 14,
                        color: Constant.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
            ),
          ),*/

          const SizedBox(
            height: 25,
          ),

          // display categories:
          FutureBuilder<List<CategoryResponse>>(
            future: ApiManagerCategories.getAllCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Constant.mainColor,
                ));
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No categories found"));
              }

              // server has data:
              List<CategoryResponse> categoryList = snapshot.data!;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: categoryList.take(3).map((category) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: CategoryCard(category: category),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: categoryList.skip(3).map((category) {
                      return Padding(
                          padding: const EdgeInsets.all(5),
                          child: CategoryCard(category: category));
                    }).toList(),
                  ),
                ],
              );
            },
          ),
            const SizedBox(
            height: 20,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Recommendation Products",
                style: TextStyle(
                    color: Constant.blackColorDark,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
              //const SizedBox( width: 110,),
              const Spacer(),
              InkWell(
                onTap: () {
                  /* Navigator.pushNamed(context, HomeScreenCategories.routeName,
                   // arguments:category,
                    );*/
                },
                child: const Row(
                  children: [
                    Text(
                      "Show All",
                      style: TextStyle(
                          color: Constant.blueColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Constant.blackColorDark,
                    )
                  ],
                ),
              ),
              const SizedBox( width: 6, )
            ],
          ),
          const SizedBox(height: 20),
          // display Bags product:
          RecommendedProductsList(),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),

              const Text(
                "Handcraft Carpets",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Constant.blackColorDark),
              ),

              // const SizedBox( width: 130,),
              const Spacer(),

              InkWell(
                onTap: () {
                  // Navigator.pushNamed(context, HomeScreenCategories.routeName,);
                  //arguments:  CategoryItemResponse.localData[21]);
                },
                child: const Row(
                  children: [
                    Text(
                      "Show All",
                      style: TextStyle(
                          color: Constant.blueColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Constant.blackColorDark,
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          // display carpets products:
          FutureBuilder<CategoryModel>(
            future: ApiManagerCategories.getProducts(12), // loading data:

            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Constant.mainColor,
                ));
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData) {
                return const Center(child: Text("No categories found"));
              }

              // server has data:

              var products =
                  snapshot.data?.allProducts ?? []; // get all products;

              return SizedBox(
                height: 350,
                width: double.infinity,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ProductPage.routeName,
                            arguments: products[index],
                          );
                        },
                        child: stacklistcart(product: products[index]));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(width: 5);
                  },
                  itemCount: products.length,
                  scrollDirection: Axis.horizontal,
                ),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),

          //Explore other products
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Shop Necklaces",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Constant.blackColorDark),
              ),

              //const SizedBox( width: 150,),
              const Spacer(),

              InkWell(
                onTap: () {},
                child: const Row(
                  children: [
                    Text(
                      "Show All",
                      style: TextStyle(
                          color: Constant.blueColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Constant.blackColorDark,
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          // display Necklace products:
          FutureBuilder<CategoryModel>(
            future: ApiManagerCategories.getProducts(9), // loading data:

            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Constant.mainColor,
                ));
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData) {
                return const Center(child: Text("No categories found"));
              }

              // server has data:

              var products =
                  snapshot.data?.allProducts ?? []; // get all products;

              return Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                height: 350,
                width: double.infinity,
                child: ListView.separated(
                  itemCount: products.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ProductPage.routeName,
                            arguments: products[index],
                          );
                        },
                        child: stacklisthandmade(
                          product: products[index],
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 15,
                    );
                  },
                ),
              );
            },
          ),

          const SizedBox(
            height: 30,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Shop Rings",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Constant.blackColorDark),
              ),

              //const SizedBox( width: 150,),
              const Spacer(),

              InkWell(
                onTap: () {},
                child: const Row(
                  children: [
                    Text(
                      "Show All",
                      style: TextStyle(
                          color: Constant.blueColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                      textAlign: TextAlign.end,
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Constant.blackColorDark,
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          // display Rings products:
          FutureBuilder<CategoryModel>(
            future: ApiManagerCategories.getProducts(13), // loading data:

            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Constant.mainColor,
                ));
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData) {
                return const Center(child: Text("No categories found"));
              }

              // server has data:

              var products =
                  snapshot.data?.allProducts ?? []; // get all products;

              return Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                height: 350,
                width: double.infinity,
                child: ListView.separated(
                  itemCount: products.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ProductPage.routeName,
                            arguments: products[index],
                          );
                        },
                        child: stacklisthandmade(
                          product: products[index],
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 15,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
