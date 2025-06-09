
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innovahub_app/Auth/register/register_screen.dart';
import 'package:innovahub_app/Products/payment_page.dart';
import 'package:innovahub_app/home/Deals/owner_product.dart';
import 'package:innovahub_app/home/add_Deal_Tap_owner.dart';
import 'package:innovahub_app/home/controller/user_home_layout_cubit/user_home_layout_cubit.dart';
import 'package:innovahub_app/home/home_Tap_Categories.dart';
import 'package:innovahub_app/home/home_Tap_Investor.dart';
import 'package:innovahub_app/home/home_Tap_User.dart';
import 'package:innovahub_app/home/home_Tap_owner.dart';
import 'package:innovahub_app/home/user_home_screen.dart';
import 'package:innovahub_app/home/register_page.dart';
import 'package:innovahub_app/profiles/Widgets/myorder.dart';
import 'package:innovahub_app/profiles/privacy_owner_investor.dart';
import 'package:innovahub_app/profiles/privacy_user.dart';
import 'package:innovahub_app/profiles/profile_tap_Investor.dart';
import 'package:innovahub_app/profiles/profile_tap_User.dart';
import 'package:innovahub_app/splash_screen.dart';
import 'package:innovahub_app/Products/cart_page.dart';
import 'package:innovahub_app/Products/checkout_address.dart';
import 'package:innovahub_app/Products/product_page.dart';
import 'package:innovahub_app/Auth/login/forget_password.dart';
import 'package:innovahub_app/Auth/login/login_screen.dart';
import 'package:innovahub_app/Auth/login/reset_password.dart';

abstract class AppRouter {
  static const String initRoute = RegisterScreen.routeName;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static Map<String, Widget Function(BuildContext)> routes() => {
        TrainingPage.routeName: (_) => const TrainingPage(),
        SplashScreen.routeName: (_) => const SplashScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        LoginScreen.routname: (_) => const LoginScreen(),
        ForgetPasswordScreen.routname: (contect) => ForgetPasswordScreen(),
        resetpassword.routname: (_) => const resetpassword(),
        UserHomeScreen.routeName: (_) => BlocProvider(
              create: (context) => UserHomeLayoutCubit(),
              child: const UserHomeScreen(),
            ),
        HomeScreenOwner.routeName: (_) => const HomeScreenOwner(),
        HomeScreenUser.routeName: (_) => const HomeScreenUser(),
        HomeScreenInvestor.routeName: (_) => const HomeScreenInvestor(),
        HomeScreenCategories.routeName: (_) => const HomeScreenCategories(),
        ProfileInvestor.routeName: (_) => const ProfileInvestor(),
        ProfileUser.routeName: (_) => const ProfileUser(),
        PrivacyUser.routeName: (_) => const PrivacyUser(),
        PrivacyOwnerInvestor.routeName: (_) => const PrivacyOwnerInvestor(),
        PublishDealScreen.routeName: (_) => const PublishDealScreen(),
        ProductPage.routeName: (_) => const ProductPage(),
        CartPage.routeName: (_) => const CartPage(),
        CheckoutAddress.routeName: (_) => const CheckoutAddress(),
        OwnerPublish.routeName: (_) => const OwnerPublish(),
        PaymentPage.routeName: (_) => const PaymentPage(),
        ReviewScreen.routeName:(_) => const ReviewScreen(),
      };
}
