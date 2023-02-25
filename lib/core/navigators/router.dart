import 'package:flutter/material.dart';
import 'package:grocery_shopping/core/navigators/route_names.dart';
import 'package:grocery_shopping/screens/auth_status.dart';
import 'package:grocery_shopping/screens/login.dart';
import 'package:grocery_shopping/features/auth/presentation/pages/onboarding_screen.dart';
import 'package:grocery_shopping/screens/cart_screen.dart';
import 'package:grocery_shopping/features/home/presentation/homeNav.dart';
import 'package:grocery_shopping/screens/home_screen.dart';
import 'package:grocery_shopping/screens/sign_up_screen.dart';


Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.onBoarding:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const OnBoardingScreen(),
      );
      case Routes.login:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: const LoginScreen(),
        );
    case Routes.signup:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const SignUpScreen(),
      );
    case Routes.homeNav:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const HomeNavigationBar(),
      );
    case Routes.home:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const HomeScreen(),
      );
    case Routes.cart:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const CartScreen(),
      );
    case Routes.authWrapper:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: const AuthStatus(),
      );


    default:
      return MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          body: Center(
            child: Text(
              'No route defined for ${settings.name}',
            ),
          ),
        ),
      );
  }
}

PageRoute _getPageRoute({String? routeName, Widget? viewToShow}) {
  return MaterialPageRoute<void>(
    settings: RouteSettings(
      name: routeName,
    ),
    builder: (_) => viewToShow!,
  );
}
