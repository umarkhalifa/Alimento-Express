import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_shopping/app/styles/app_colors.dart';
import 'package:grocery_shopping/app/styles/fonts.dart';
import 'package:grocery_shopping/app/styles/ui_helpers.dart';
import 'package:grocery_shopping/core/constants/spacing.dart';
import 'package:grocery_shopping/data/firebase_methods.dart';
import 'package:grocery_shopping/data/order_model.dart';
import 'package:grocery_shopping/features/home/data/grocery_model.dart';

class HomeDetail extends StatefulWidget {
  final Grocery grocery;

  const HomeDetail({Key? key, required this.grocery}) : super(key: key);

  @override
  State<HomeDetail> createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> {
  int currentNumber = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: SizedBox(
        height: screenHeight(context),
        width: screenWidth(context),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.base,
                    ),
                  ),
                ),
              ),
              gapMedium,
              SizedBox(
                  height: screenHeight(context) * 0.4,
                  width: screenWidth(context),
                  child: CachedNetworkImage(
                    imageUrl: widget.grocery.image,
                    placeholder: (context, url) {
                      return const Center(
                        child: SpinKitFadingCircle(
                          color: AppColors.green,
                        ),
                      );
                    },
                    errorWidget: (context, url, widget) {
                      return const Center(
                        child: Icon(
                          Icons.error,
                          color: AppColors.green,
                        ),
                      );
                    },
                  )),
              gapLarge,
              Expanded(
                child: Container(
                  height: screenHeight(context),
                  width: screenWidth(context),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.green.withOpacity(0.3),
                            offset: const Offset(0, 8),
                            blurRadius: 20)
                      ]),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gapMedium,
                      Heading(
                        widget.grocery.name,
                        color: AppColors.base,
                        fontSize: 30,
                      ),
                      gapMedium,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RatingBar(
                            ratingWidget: RatingWidget(
                              full: const Icon(
                                Icons.star,
                                color: AppColors.green,
                              ),
                              half: const Icon(Icons.star_half),
                              empty: Icon(
                                Icons.star,
                                color: AppColors.base.withOpacity(0.2),
                              ),
                            ),
                            onRatingUpdate: (rating) {},
                            itemSize: 20,
                            initialRating: widget.grocery.rating,
                          ),
                          Container(
                            height: 30,
                            width: 96,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.blue.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 2),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (currentNumber > 1) {
                                      setState(() {
                                        currentNumber--;
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        color: AppColors.green,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Icon(
                                      Icons.remove,
                                      color: AppColors.white,
                                      size: 19,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                TextSemiBold(
                                  "$currentNumber",
                                  color: AppColors.base,
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentNumber++;
                                    });
                                  },
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      color: AppColors.green,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: AppColors.white,
                                      size: 19,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      gapMedium,
                      TextBody(
                        "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate ",
                        color: AppColors.grey,
                        maxLines: 4,
                        softWrap: true,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextBody(
                                "Total Price",
                                color: AppColors.base,
                              ),
                              Heading(
                                "N${widget.grocery.price * currentNumber}",
                                color: AppColors.base,
                              )
                            ],
                          ),
                          const Spacer(),
                          Consumer(
                            builder: (BuildContext context, WidgetRef ref,
                                Widget? child) {
                              return GestureDetector(
                                onTap: () async {
                                  final grocery = widget.grocery;
                                  await ref.read(firebaseProvider).addToCart(
                                        Cart(
                                            image: grocery.image,
                                            price: grocery.price.round(),
                                            name: grocery.name,
                                            amount: currentNumber),
                                      );
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: TextBody(
                                          "Added to cart successfully",
                                          color: AppColors.white,
                                        ),
                                        backgroundColor: Colors.green,
                                        duration:
                                            const Duration(milliseconds: 600),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  height: screenHeight(context) * 0.07,
                                  width: screenWidth(context) * 0.45,
                                  decoration: BoxDecoration(
                                    color: AppColors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Heading(
                                      "Add to Cart",
                                      fontSize: 16,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
