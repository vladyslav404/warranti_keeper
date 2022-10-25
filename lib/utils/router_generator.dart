import 'package:flutter/material.dart';
import 'package:keep_it_g/constants/routes.dart';
import 'package:keep_it_g/models/api_models/product_model.dart';
import 'package:keep_it_g/view/screens/auth_screens/sign_in_screen.dart';
import 'package:keep_it_g/view/screens/auth_screens/sign_up_screen.dart';
import 'package:keep_it_g/view/screens/create_product_screen/create_product_screen.dart';
import 'package:keep_it_g/view/screens/home_screen/home_screen.dart';
import 'package:keep_it_g/view/screens/navigation_screen.dart';
import 'package:keep_it_g/view/screens/profile_screen/profile_screen.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        switch (settings.name) {
          case ConstRoutes.navigationScreen:
            return const NavigationScreen();
          case ConstRoutes.homeScreen:
            return HomeScreen();
          case ConstRoutes.profileScreen:
            return const ProfileScreen();
          case ConstRoutes.signInScreen:
            return const SignInScreen();
          case ConstRoutes.signUpScreen:
            return const SignUpScreen();
          case ConstRoutes.createProductScreen:
            if (settings.arguments is ProductModel && settings.arguments != null) {
              return CreateProductScreen(productModel: settings.arguments as ProductModel);
            } else {
              return const CreateProductScreen();
            }
          default:
            return Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            );
        }
      },
      transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
    );
  }
}
