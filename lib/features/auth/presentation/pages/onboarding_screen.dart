import 'package:flutter/material.dart';
import 'package:grocery_shopping/app/styles/app_colors.dart';
import 'package:grocery_shopping/app/styles/app_gradients.dart';
import 'package:grocery_shopping/app/styles/fonts.dart';
import 'package:grocery_shopping/app/styles/ui_helpers.dart';
import 'package:grocery_shopping/core/constants/app_assets.dart';
import 'package:grocery_shopping/core/constants/spacing.dart';
import 'package:grocery_shopping/core/navigators/route_names.dart';
import 'package:grocery_shopping/features/home/data/grocery_model.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SizedBox(
        height: screenHeight(context),
        width: screenWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.green.withOpacity(0.1)),
              child: Image.asset(AppAssets.logo),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextSemiBold(
                "Get your groceries delivered to your home",
                color: AppColors.base,
                fontSize: 25,
                textAlign: TextAlign.center,
              ),
            ),
            gapMedium,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextBody(
                "The best delivery app in town for delivering your daily fresh groceries",
                softWrap: true,
                color: AppColors.grey.withOpacity(0.6),
                textAlign: TextAlign.center,
              ),
            ),
            gapMedium2,
            GestureDetector(
              onTap: () {
                // FirebaseMeth().addTickets();
                Navigator.pushNamed(context, Routes.login);
              },
              child: Container(
                height: 52,
                width: screenWidth(context) * 0.4,
                decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: TextSemiBold(
                    "Get Started",
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            gapMedium,
            gapMedium,
            SizedBox(
              height: screenHeight(context) * 0.4,
              width: screenWidth(context),
              child: Image.asset(
                AppAssets.splash2,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }
}
