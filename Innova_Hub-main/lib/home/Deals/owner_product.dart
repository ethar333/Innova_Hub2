import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:innovahub_app/Custom_Widgets/Custom_Dropdownmenue.dart';
import 'package:innovahub_app/Custom_Widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class OwnerPublish extends StatefulWidget {
  const OwnerPublish({Key? key}) : super(key: key);

  static const String routeName = 'owner_publish';

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<OwnerPublish> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController dimensionsController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController sizeNamesController = TextEditingController();
  TextEditingController colorNamesController = TextEditingController();
  File? _image1;
  File? _image2;
  File? _image3;
  final _formKey = GlobalKey<FormState>();

  File? homePicture;
  List<File> pictures = [];
  Set<String> selectedColors = {};

  final picker = ImagePicker();

  Future<void> pickHomePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        homePicture = File(pickedFile.path);
      });

      print("✅ Home picture selected: ${homePicture!.path}");
    } else {
      print("⚠ No image selected");
    }
  }

  // اختيار صور إضافية
  Future<void> pickOtherPicture(int imageNumber) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        switch (imageNumber) {
          case 2:
            _image2 = File(pickedFile.path);
            break;
          case 3:
            _image3 = File(pickedFile.path);
            break;
        }
      });

      print("✅ Image $imageNumber selected: ${pickedFile.path}");
    } else {
      print("⚠ No image selected for $imageNumber");
    }
  }

  Future<void> _pickImage(int imageNumber) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (imageNumber == 1) {
          _image1 = File(pickedFile.path);
        } else if (imageNumber == 2) {
          _image2 = File(pickedFile.path);
        } else if (imageNumber == 3) {
          _image3 = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate()) {
      showErrorMessage("Please fill all required fields.");
      return;
    }

    if (homePicture == null || !homePicture!.existsSync()) {
      showErrorMessage("Please select a home picture.");
      print("DEBUG: No home picture selected.");
      return;
    }

    if (_image2 == null && _image3 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠ Please select at least one additional photo."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        throw Exception("User is not authenticated!");
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://innova-hub.premiumasp.net/api/Product"),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      request.fields['ProductName'] = productNameController.text;
      request.fields['Description'] = descriptionController.text;
      request.fields['Price'] = priceController.text;
      request.fields['Discount'] = discountController.text;
      request.fields['CategoryId'] = categoryIdController.text;
      request.fields['Stock'] = stockController.text;
      request.fields['Dimensions'] = dimensionsController.text;
      request.fields['Weight'] = weightController.text;
      request.fields['SizeNames'] = sizeNamesController.text;
      request.fields['ColorNames'] = colorNamesController.text;

      request.files.add(
          await http.MultipartFile.fromPath('HomePicture', homePicture!.path));

      // ✅ Only add additional images if they are not null
      if (_image2 != null) {
        request.files
            .add(await http.MultipartFile.fromPath('Pictures', _image2!.path));
      }

      if (_image3 != null) {
        request.files
            .add(await http.MultipartFile.fromPath('Pictures', _image3!.path));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product added successfully!")),
        );
      } else {
        var errorMessage = decodedResponse['errors']?['Pictures']?.first ??
            decodedResponse['Message'] ??
            "Unknown error occurred";

        print("❌ Server Error: $errorMessage");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $errorMessage")),
        );
      }
    } catch (e) {
      print("❌ Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e")),
      );
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
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
        backgroundColor: Constant.mainColor,
        automaticallyImplyLeading: false,
        title: const Text(
          "Publish Your Product",
          style: TextStyle(fontSize: 16, color: Constant.whiteColor,fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Constant.whiteColor,
                  ))),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Product Name : ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Constant.blackColorDark,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 230,
                      height: 35,
                      child: CustomTextField(controller: productNameController),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Product Category : ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Constant.blackColorDark,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Constant.whiteColor,
                        borderRadius: BorderRadius.circular(8),
                        border:Border.all(
                          color: Constant.greyColor,
                        )
                      ),
                      height: 50,
                      width: 200,
                      child: dropdownmenueforcatregory(
                        categoryIdController: categoryIdController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Description : ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Constant.blackColorDark,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 230,
                      height: 100,
                      child: CustomTextField(
                        controller: descriptionController,
                        maxLines: 5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Price: ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.blackColorDark,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 170,
                          height: 30,
                          child: CustomTextField(controller: priceController),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Discount: ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.blackColorDark,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 170,
                          height: 30,
                          child:
                              CustomTextField(controller: discountController),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Weight (Kg): ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.blackColorDark,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 170,
                          height: 30,
                          child: CustomTextField(controller: weightController),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Dimensions(L×W×H) : ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.blackColorDark,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 170,
                          height: 30,
                          child:
                              CustomTextField(controller: dimensionsController),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Row(
                  children: [
                    Text(
                      "Availability:",
                      style: TextStyle(
                          fontSize: 16,
                          color: Constant.mainColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Product Color: ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Constant.blackColorDark,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Constant.whiteColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Constant.greyColor,
                        ),
                      ),
                      height: 40,
                      width: double.infinity,
                      child: DropdownMenuForcolor(
                        colorNamesController: colorNamesController,
                      ),
                    ),
                  ],
                ),
                 const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Product Size: ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Constant.blackColorDark,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Constant.whiteColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Constant.greyColor,
                        ),
                      ),
                      height: 40,
                      width: double.infinity,
                      child: DropdownMenuForsize(
                        sizeNamesController: sizeNamesController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),

               Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Stock Availability: ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Constant.blackColorDark,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                     SizedBox(
                       height: 35,
                       child: CustomTextField(controller: stockController),
                     ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => pickHomePicture(),
                      child: Container(
                        width: 200,
                        height: 270,
                        decoration: BoxDecoration(
                          color: Constant.white4Color,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: homePicture != null
                            ? Image.file(homePicture!, fit: BoxFit.cover)
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.file_upload,
                                    size: 30,
                                    color: Constant.blackColorDark,
                                  ),
                                  Text(
                                    "Home Picture",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Constant.blackColorDark),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => pickOtherPicture(2),
                          child: Container(
                            width: 140,
                            height: 130,
                            decoration: BoxDecoration(
                              color: Constant.white4Color,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: _image2 != null
                                ? Image.file(_image2!, fit: BoxFit.cover)
                                : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.file_upload,
                                        size: 30,
                                        color: Constant.blackColorDark,
                                      ),
                                      Text(
                                        "Other Pictures",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Constant.blackColorDark),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => pickOtherPicture(3),
                          child: Container(
                            width: 140,
                            height: 130,
                            decoration: BoxDecoration(
                              color: Constant.white4Color,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: _image3 != null
                                ? Image.file(_image3!, fit: BoxFit.cover)
                                : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.file_upload,
                                        size: 30,
                                        color: Constant.blackColorDark,
                                      ),
                                      Text(
                                        "Other Pictures",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Constant.blackColorDark),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      addProduct();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.mainColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Publish Deal',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}













/*import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:innovahub_app/Custom_Widgets/Custom_Dropdownmenue.dart';
import 'package:innovahub_app/Custom_Widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class OwnerPublish extends StatefulWidget {
  const OwnerPublish({Key? key}) : super(key: key);

  static const String routeName = 'owner_publish';

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<OwnerPublish> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController dimensionsController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController sizeNamesController = TextEditingController();
  TextEditingController colorNamesController = TextEditingController();
  File? _image1;
  File? _image2;
  File? _image3;
  final _formKey = GlobalKey<FormState>();

  File? homePicture;
  List<File> pictures = [];
  Set<String> selectedColors = {};

  final picker = ImagePicker();

  Future<void> pickHomePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        homePicture = File(pickedFile.path);
      });

      print("✅ Home picture selected: ${homePicture!.path}");
    } else {
      print("⚠ No image selected");
    }
  }

  Future<void> pickOtherPicture(int imageNumber) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        switch (imageNumber) {
          case 2:
            _image2 = File(pickedFile.path);
            break;
          case 3:
            _image3 = File(pickedFile.path);
            break;
        }
      });

      print("✅ Image $imageNumber selected: ${pickedFile.path}");
    } else {
      print("⚠ No image selected for $imageNumber");
    }
  }

  Future<void> _pickImage(int imageNumber) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (imageNumber == 1) {
          _image1 = File(pickedFile.path);
        } else if (imageNumber == 2) {
          _image2 = File(pickedFile.path);
        } else if (imageNumber == 3) {
          _image3 = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate()) {
      showErrorMessage("Please fill all required fields.");
      return;
    }

    if (homePicture == null || !homePicture!.existsSync()) {
      showErrorMessage("Please select a home picture.");
      print("DEBUG: No home picture selected.");
      return;
    }

    if (_image2 == null && _image3 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠ Please select at least one additional photo."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        throw Exception("User is not authenticated!");
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://innova-hub.premiumasp.net/api/Product"),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      request.fields['ProductName'] = productNameController.text;
      request.fields['Description'] = descriptionController.text;
      request.fields['Price'] = priceController.text;
      request.fields['Discount'] = discountController.text;
      request.fields['CategoryId'] = categoryIdController.text;
      request.fields['Stock'] = stockController.text;
      request.fields['Dimensions'] = dimensionsController.text;
      request.fields['Weight'] = weightController.text;
      request.fields['SizeNames'] = sizeNamesController.text;
      request.fields['ColorNames'] = colorNamesController.text;

      request.files.add(
          await http.MultipartFile.fromPath('HomePicture', homePicture!.path));

      // ✅ Only add additional images if they are not null
      if (_image2 != null) {
        request.files
            .add(await http.MultipartFile.fromPath('Pictures', _image2!.path));
      }

      if (_image3 != null) {
        request.files
            .add(await http.MultipartFile.fromPath('Pictures', _image3!.path));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product added successfully!")),
        );
      } else {
        var errorMessage = decodedResponse['errors']?['Pictures']?.first ??
            decodedResponse['Message'] ??
            "Unknown error occurred";

        print("❌ Server Error: $errorMessage");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $errorMessage")),
        );
      }
    } catch (e) {
      print("❌ Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e")),
      );
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
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
        backgroundColor: Constant.mainColor,
        automaticallyImplyLeading: false,
        title: const Text(
          "Publish Your Product",
          style: TextStyle(
            fontSize: 16,
            color: Constant.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: Constant.whiteColor,
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: 
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20 ,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Product Name : ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.blackColorDark,
                              fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: SizedBox(
                           // width: 230,
                            height: 30,
                            child: CustomTextField(
                                controller: productNameController),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Product Category : ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.blackColorDark,
                              fontWeight: FontWeight.w500),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Constant.whiteColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Constant.greyColor,
                            )
                          ),
                          height: 50,
                          width: 200,
                          child: dropdownmenueforcatregory(
                            categoryIdController: categoryIdController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Description : ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.blackColorDark,
                              fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: SizedBox(
                           // width: 230,
                            height: 100,
                            child: CustomTextField(
                              controller: descriptionController,
                              maxLines: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Price : ",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Constant.blackColorDark,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: 170,
                              height: 30,
                              child:
                                  CustomTextField(controller: priceController),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Discount : ",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Constant.blackColorDark,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: 170,
                              height: 30,
                              child: CustomTextField(
                                  controller: discountController),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Weight (Kg): ",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Constant.blackColorDark,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: 170,
                              height: 30,
                              child:
                                  CustomTextField(controller: weightController),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             const Text(
                              "Dimensions(L×W×H) : ",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Constant.blackColorDark,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: 170,
                              height: 30,
                              child: CustomTextField(
                                  controller: dimensionsController),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      children: [
                        Text(
                          "Availability:",
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.mainColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Product Color : ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Constant.blackColorDark,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width:double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Constant.whiteColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Constant.greyColor,
                                  ),
                                ),
                                child: DropdownMenuForcolor(
                                  colorNamesController: colorNamesController,
                                ),
                              ),
                            ],
                          ),
                        ),
                       /* Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Size : ",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Constant.blackColorDark,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Constant.white4Color,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Constant.white4Color,
                                ),
                              ),
                              height: 40,
                              width: 170,
                              child: DropdownMenuForsize(
                                sizeNamesController: sizeNamesController,
                              ),
                            ),
                          ],
                        ),*/
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Stock Availability : ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Constant.blackColorDark,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 30,
                          child: CustomTextField(controller: stockController),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => pickHomePicture(),
                          child: Container(
                            width: 200,
                            height: 270,
                            decoration: BoxDecoration(
                              color: Constant.white4Color,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: homePicture != null
                                ? Image.file(homePicture!, fit: BoxFit.cover)
                                : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.file_upload,
                                        size: 30,
                                        color: Constant.blackColorDark,
                                      ),
                                      Text(
                                        "Home Picture",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Constant.blackColorDark),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () => pickOtherPicture(2),
                              child: Container(
                                width: 140,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Constant.white4Color,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: _image2 != null
                                    ? Image.file(_image2!, fit: BoxFit.cover)
                                    : const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.file_upload,
                                            size: 30,
                                            color: Constant.blackColorDark,
                                          ),
                                          Text(
                                            "Other Pictures",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Constant.blackColorDark),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => pickOtherPicture(3),
                              child: Container(
                                width: 140,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Constant.white4Color,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: _image3 != null
                                    ? Image.file(_image3!, fit: BoxFit.cover)
                                    : const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.file_upload,
                                            size: 30,
                                            color: Constant.blackColorDark,
                                          ),
                                          Text(
                                            "Other Pictures",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Constant.blackColorDark),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          addProduct();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constant.mainColor,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Publish Deal',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
            
          ),
        ),
      ),
    );
  }
}*/


