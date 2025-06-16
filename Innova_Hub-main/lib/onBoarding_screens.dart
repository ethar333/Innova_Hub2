
import 'package:flutter/material.dart';
import 'package:innovahub_app/Auth/register/register_screen.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';


class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Customer",
      "description":
          "Discover the latest products and deals from innovative businesses, and support entrepreneurs with ease through Innova Hub.",
      "image": "assets/images/Customer_screen.png"
    },
    {
      "title": "Business Owner",
      "description":
          "Create and promote your products and exclusive deals, and connect directly with investors through the Innova Hub platform.",
      "image": "assets/images/Owner_screen.png"
    },
    {
      "title": "Investor",
      "description":
          "Explore promising investment opportunities in startups and become part of their success stories with Innova Hub.",
      "image": "assets/images/Investor_screen.png"
    },
  ];

  void _nextPage() {
    if (_currentIndex < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF232323),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemCount: _onboardingData.length,
        itemBuilder: (context, index) {
          final item = _onboardingData[index];
          return Container(
            width: screenWidth,
            height: screenHeight,
            color: Colors.white,
            child: Column(
              children: [
                // Top section
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 32),
                        const Text(
                          'Innova',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: screenHeight * 0.3,
                          child: Image.asset(
                            item['image']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom section
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Constant.mainColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            item['description']!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: _nextPage,
                              child: const Text(
                                'Next >',
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


/*class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';        // route name:

  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Customer",
      "description":
          "Discover the latest products and deals from innovative businesses, and support entrepreneurs with ease through Innova Hub.",
      "image": "assets/images/Customer_screen.png"
    },
    {
      "title": "Business Owner",
      "description":
          "Create and showcase your products and exclusive deals, and connect directly with investors through the Innova Hub platform.",
      "image": "assets/images/Owner_screen.png"
    },
    {
      "title": "Investor",
      "description":
          "Explore promising investment opportunities in startups and become part of their success stories with Innova Hub.",
      "image": "assets/images/Investor_screen.png"
    },
  ];

  void _nextPage() {
    if (_currentIndex < _onboardingData.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemCount: _onboardingData.length,
        itemBuilder: (context, index) {
          final item = _onboardingData[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Text(
                "Innova",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Image.asset(item['image']!, height: 300),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: const BoxDecoration(
                    color: Color(0xFF004F80),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        item['description']!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: _nextPage,
                          child: const Text(
                            "Next >",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}*/
