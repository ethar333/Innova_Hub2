
import 'package:flutter/material.dart';
import 'package:innovahub_app/Products/product_page.dart';
import 'package:innovahub_app/core/Api/Api_Manager_categories.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/Custom_Widgets/Estimated_container.dart';
import 'package:innovahub_app/Custom_Widgets/Stack_listCart.dart';
import 'package:innovahub_app/Custom_Widgets/category_card.dart';
import 'package:innovahub_app/Custom_Widgets/container_owner.dart';
import 'package:innovahub_app/Custom_Widgets/stack_listHandmade.dart';
import 'package:innovahub_app/Models/Category_response.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/home/Deals/owner_product.dart';

class HomeOwner extends StatelessWidget {
  const HomeOwner({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Constant.mainColor,
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                fillColor: Constant.whiteColor,
                filled: true,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Constant.greyColor2,
                ),
                hintText: 'Search any Product...',
                hintStyle:
                    const TextStyle(color: Constant.greyColor2, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Constant.whiteColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Constant.whiteColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(color: Constant.whiteColor),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),

          Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/owner1.png",
                ),
                const SizedBox(
                  width: 10,
                ),
                const Expanded(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mohamed Ali',
                        style: TextStyle(
                          color: Constant.blackColorDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Constant.blue3Color,
                            child: Icon(
                              Icons.check,
                              color: Constant.whiteColor,
                              size: 18,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Verified',
                            style: TextStyle(
                              color: Constant.greyColor3,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID:2333669591',
                      style: TextStyle(
                        color: Constant.greyColor,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
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
                  onTap: (){

                    Navigator.pushNamed(context, OwnerPublish.routeName);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Constant.mainColor, // لون الـ border
                        width: 3, // سمك الـ border
                      ),
                    ),
                    child: const CircleAvatar(
                        backgroundColor: Constant.whiteColor,
                        radius: 15,
                        child: Icon(
                          Icons.add,
                          color: Constant.mainColor,
                          size: 30,
                        )),
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
          
         const ContainerOwner(),

          const SizedBox(
            height: 4,
          ),
          Container(
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
          ),

           const SizedBox(height: 15,),

           // display categories:
         FutureBuilder<List<CategoryResponse>>(
        future: ApiManagerCategories.getAllCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Center(child: CircularProgressIndicator(
             color:Constant.mainColor,
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
                      child: CategoryCard(category: category)
                    );
                  }).toList(),
                ),
              ],
          );
        },
      ),

           const SizedBox(height: 20,),
            Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),

              const Text(
                "Handcraft Carpets",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Constant.blackColorDark),
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
                      fontWeight:FontWeight.w400,
                      fontSize: 15),
                     ),
                    Icon(Icons.chevron_right,color: Constant.blackColorDark,)
                     
                    ],
                  ),
                ),
                const SizedBox(width: 10,)
            ],
          ),
      
          const SizedBox(
            height: 20,
          ),
         
         // display carpets products:
       FutureBuilder<CategoryModel>(
        future: ApiManagerCategories.getProducts(12),      // loading data:

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Center(child: CircularProgressIndicator(color: Constant.mainColor,));

          } else if (snapshot.hasError) {

            return Center(child: Text("Error: ${snapshot.error}"));

          } else if (!snapshot.hasData ) {

            return const Center(child: Text("No categories found"));
          }
 
          // server has data:

         var products = snapshot.data?.allProducts ?? [];     // get all products;

          return SizedBox(
            height: 350,
            width: double.infinity,
            child: ListView.separated(
              itemBuilder: (context,index){

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ProductPage.routeName,
                    arguments: products[index],);
                  },
                child: stacklistcart(product: products[index]));
              } , 
              separatorBuilder:(BuildContext context, int index) {
                  return const SizedBox(width: 5);
                  },
               itemCount: products.length,
               scrollDirection: Axis.horizontal,
               
            ),
          );
        },
      ),
        const SizedBox(height: 20,),

          //Explore other products
           Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Shop Necklaces",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Constant.blackColorDark),
              ),
              
              //const SizedBox( width: 150,),
                const Spacer(),


               InkWell(
                onTap: () {
                },
                 child: const Row(
                   children: [
                     Text(
                      "Show All",
                      style: TextStyle(
                      color: Constant.blueColor,
                      fontWeight:FontWeight.w400,
                      fontSize: 15),
                     ),
                   
                    Icon(Icons.chevron_right,color: Constant.blackColorDark,)
                 
                   ],
                 ),
               ),
                const SizedBox(width: 10,)

            ],
          ),
      
          const SizedBox(
            height: 20,
          ),


        // display Necklace products:
        FutureBuilder<CategoryModel>(
        future: ApiManagerCategories.getProducts(9),      // loading data:

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Center(child: CircularProgressIndicator(color: Constant.mainColor,));

          } else if (snapshot.hasError) {

            return Center(child: Text("Error: ${snapshot.error}"));

          } else if (!snapshot.hasData ) {

            return const Center(child: Text("No categories found"));
          }
 
          // server has data:

         var products = snapshot.data?.allProducts ?? [];     // get all products;

          return Container(
             margin: const EdgeInsets.only(left: 15,right: 15),
             height: 350,
             width: double.infinity,
             child: ListView.separated(
               itemCount: products.length,
               scrollDirection: Axis.horizontal,
               itemBuilder: (context, index) {

                 return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ProductPage.routeName,
                    arguments: products[index],
                    );
                  },
                  child: stacklisthandmade(product: products[index],));

               },
               separatorBuilder: (BuildContext context, int index) {
                 return const SizedBox( width: 15, );

               },
             ),
          );
        },
      ),

         const SizedBox(height: 30,),

        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Shop Rings",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Constant.blackColorDark),
              ),
              
              //const SizedBox( width: 150,),
              const Spacer(),

               InkWell(
                onTap: () {
                },
                 child: const Row(
                   children: [
                     Text(
                      "Show All",
                      style: TextStyle(
                      color: Constant.blueColor,
                      fontWeight:FontWeight.w400,
                      fontSize: 15),
                      textAlign: TextAlign.end,
                     ),
                   
                    Icon(Icons.chevron_right,color: Constant.blackColorDark,)
                 
                   ],
                 ),
               ),
                const SizedBox(width: 10,)

            ],
          ),

          const SizedBox(height: 20,),

       // display Rings products:
        FutureBuilder<CategoryModel>(
        future: ApiManagerCategories.getProducts(13),      // loading data:

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Center(child: CircularProgressIndicator(color: Constant.mainColor,));

          } else if (snapshot.hasError) {

            return Center(child: Text("Error: ${snapshot.error}"));

          } else if (!snapshot.hasData ) {

            return const Center(child: Text("No categories found"));
          }
 
          // server has data:

         var products = snapshot.data?.allProducts ?? [];     // get all products;

          return Container(
             margin: const EdgeInsets.only(left: 15,right: 15),
             height: 350,
             width: double.infinity,
             child: ListView.separated(
               itemCount: products.length,
               scrollDirection: Axis.horizontal,
               itemBuilder: (context, index) {

                 return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ProductPage.routeName,
                    arguments: products[index],);
                  },
                  child: stacklisthandmade(product: products[index],));

               },
               separatorBuilder: (BuildContext context, int index) {
                 return const SizedBox( width: 15, );

               },
             ),
          );
        },
      ),
          /*const SizedBox(
            height: 40,
          ),*/
        ],

      ),
    );
  }
}

