import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_shopping/app/styles/app_colors.dart';
import 'package:grocery_shopping/app/styles/fonts.dart';
import 'package:grocery_shopping/app/styles/ui_helpers.dart';
import 'package:grocery_shopping/data/firebase_methods.dart';
import 'package:grocery_shopping/data/order_model.dart';
import 'package:grocery_shopping/domain/providers.dart';
import 'package:grocery_shopping/features/home/data/grocery_model.dart';
import 'package:grocery_shopping/features/home/presentation/pages/homeDetail.dart';

import '../core/constants/spacing.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String query;

  const SearchScreen({Key? key, required this.query}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final grocery = ref.read(fetchGroceriesProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.base),
        elevation: 0,
        centerTitle: true,
        title: TextSemiBold(
          "Search",
          fontSize: 16,
          color: AppColors.base,
        ),
      ),
      body: grocery.when(
        data: (data) {
          final List<Grocery> groceries = data
              .where(
                (element) => element.name.toLowerCase().contains(
                      widget.query.toLowerCase(),
                    ),
              )
              .toList();
          return groceries.isNotEmpty
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 0.85),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeDetail(
                              grocery: groceries[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: screenHeight(context),
                        width: screenWidth(context) * 0.45,
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: screenHeight(context) * 0.12,
                              width: screenWidth(context),
                              child: Image.network(
                                groceries[index].image,
                              ),
                            ),
                            const Spacer(),
                            TextSemiBold(
                              groceries[index].name,
                              fontSize: 15,
                              color: AppColors.base,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RatingBar(
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
                                initialRating: groceries[index].rating,
                              ),
                            ),
                            Row(
                              children: [
                                TextSemiBold(
                                  "N${groceries[index].price}",
                                  fontSize: 16,
                                  color: AppColors.green,
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        int amount = 1;
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                              child: Container(
                                                height: screenHeight(context) *
                                                    0.62,
                                                width: screenWidth(context),
                                                color: AppColors.white,
                                                child: Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 20.0,
                                                                left: 20),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: CircleAvatar(
                                                            radius: 17,
                                                            backgroundColor:
                                                                AppColors.blue
                                                                    .withOpacity(
                                                                        0.1),
                                                            child: const Icon(
                                                              FontAwesomeIcons
                                                                  .x,
                                                              size: 15,
                                                              color: AppColors
                                                                  .base,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    SizedBox(
                                                      height: screenHeight(
                                                              context) *
                                                          0.2,
                                                      width:
                                                          screenWidth(context),
                                                      child: CachedNetworkImage(
                                                        imageUrl: groceries[index].image,
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
                                                      )
                                                    ),
                                                    gapSmall,
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 20.0,
                                                              left: 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          TextSemiBold(
                                                            groceries[index]
                                                                .name,
                                                            fontSize: 18,
                                                            color:
                                                                AppColors.base,
                                                          ),
                                                          TextSemiBold(
                                                            "N${groceries[index].price}",
                                                            fontSize: 18,
                                                            color:
                                                                AppColors.base,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 9,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 20.0,
                                                              left: 20),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: RatingBar(
                                                          ratingWidget:
                                                              RatingWidget(
                                                            full: const Icon(
                                                              Icons.star,
                                                              color: AppColors
                                                                  .green,
                                                            ),
                                                            half: const Icon(
                                                                Icons
                                                                    .star_half),
                                                            empty: Icon(
                                                              Icons.star,
                                                              color: AppColors
                                                                  .base
                                                                  .withOpacity(
                                                                      0.2),
                                                            ),
                                                          ),
                                                          onRatingUpdate:
                                                              (rating) {},
                                                          itemSize: 20,
                                                          initialRating:
                                                              groceries[index]
                                                                  .rating,
                                                        ),
                                                      ),
                                                    ),
                                                    gapSmall,
                                                    const Divider(),
                                                    gapMedium,
                                                    TextBody(
                                                        "How many do you want"),
                                                    gapMedium,
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            if (amount > 1) {
                                                              setState(() {
                                                                amount--;
                                                              });
                                                            }
                                                          },
                                                          child: const Icon(
                                                            FontAwesomeIcons
                                                                .minus,
                                                            color:
                                                                AppColors.blue,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Container(
                                                          height: 60,
                                                          width: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .base),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Center(
                                                            child: Heading(
                                                              amount.toString(),
                                                              color: AppColors
                                                                  .base,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            amount++;
                                                            setState(() {});
                                                          },
                                                          child: const Icon(
                                                            FontAwesomeIcons
                                                                .plus,
                                                            color:
                                                                AppColors.blue,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    gapMedium,
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        final grocery =
                                                            groceries[index];
                                                        await ref
                                                            .read(
                                                                firebaseProvider)
                                                            .addToCart(Cart(
                                                                image: grocery
                                                                    .image,
                                                                price: grocery
                                                                    .price
                                                                    .round(),
                                                                name: grocery
                                                                    .name,
                                                                amount:
                                                                    amount));
                                                        if (mounted) {
                                                          Navigator.pop(
                                                              context);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: TextBody(
                                                                "Added to cart successfully",
                                                                color: AppColors
                                                                    .white,
                                                              ),
                                                              backgroundColor:
                                                                  Colors.green,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          600),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 56,
                                                        width: screenWidth(
                                                            context),
                                                        decoration:
                                                            const BoxDecoration(
                                                                color: AppColors
                                                                    .green),
                                                        child: Center(
                                                          child: TextSemiBold(
                                                            "Add to cart",
                                                            color:
                                                                AppColors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: AppColors.green,
                                    child: Icon(
                                      FontAwesomeIcons.bagShopping,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: groceries.length,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                )
              : SizedBox(
                  height: screenHeight(context),
                  width: screenWidth(context),
                  child: Center(
                    child: TextSemiBold(
                      "No Item Available",
                      color: AppColors.base,
                    ),
                  ),
                );
        },
        error: (_, __) {
          return const Text("error");
        },
        loading: () {
          return SizedBox(
            height: screenHeight(context),
            width: screenWidth(context),
            child: const Center(
              child: SpinKitChasingDots(
                color: AppColors.green,
              ),
            ),
          );
        },
      ),
    );
  }
}
