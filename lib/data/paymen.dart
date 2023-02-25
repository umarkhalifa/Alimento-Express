import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_shopping/app/styles/app_colors.dart';
import 'package:grocery_shopping/app/styles/fonts.dart';
import 'package:grocery_shopping/app/styles/ui_helpers.dart';
import 'package:grocery_shopping/core/constants/spacing.dart';
import 'package:grocery_shopping/data/firebase_methods.dart';
import 'package:grocery_shopping/features/home/presentation/homeNav.dart';
import 'package:riverpod/riverpod.dart';

class Payment {
  BuildContext context;
  WidgetRef ref;
  int price;
  String email;

  Payment(
      {required this.price,
      required this.context,
      required this.email,
      required this.ref});

  // Create an instance of payStack
  PaystackPlugin payStack = PaystackPlugin();

  // Create Reference

  String _getReference() {
    String platform;
    if (Platform.isAndroid) {
      platform = "Android";
    } else {
      platform = "iOS";
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  // Initialize payStack
  Future initializePlugin() async {
    await payStack.initialize(
        publicKey: "pk_test_14188f77ca2e1cbf6e6435b1a86fa9a7afa72646");
  }

//  Get card ui
  PaymentCard _getCardUi() {
    return PaymentCard(number: "", cvc: "", expiryMonth: 0, expiryYear: 0);
  }

//  Charge card
  chargeCard() async {
    initializePlugin().then(
      (_) async {
        Charge charge = Charge()
          ..amount = price * 100
          ..email = email
          ..reference = _getReference()
          ..card = _getCardUi();

        CheckoutResponse response = await payStack.checkout(
          context,
          charge: charge,
          method: CheckoutMethod.card,
          fullscreen: false,
          logo: const FlutterLogo(
            size: 24,
          ),
        );
        if (response.status == true) {
          await ref.read(firebaseProvider).addOrder();
          showDialog(
            context: context,
            barrierDismissible: false,
            // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.green,
                        size: 150,
                      ),
                      gapMedium,
                      Heading(
                        "Your order is successful",
                        fontSize: 20,
                        color: AppColors.base,
                      ),
                      gapMedium,
                    ],
                  ),
                ),
                actions: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ref.read(homeIndex.notifier).state = 2;
                    },
                    child: Container(
                      height: 52,
                      width: screenWidth(context),
                      decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: TextSemiBold(
                          "Continue",
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      const Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 150,
                      ),
                      gapMedium,
                      Heading(
                        "Transaction Failed",
                        fontSize: 20,
                        color: AppColors.base,
                      ),
                      gapMedium,
                    ],
                  ),
                ),
                actions: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 52,
                      width: screenWidth(context),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: TextSemiBold(
                          "Continue",
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        }
      },
    );
  }
}
