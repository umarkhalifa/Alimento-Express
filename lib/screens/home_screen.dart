import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_shopping/app/styles/app_colors.dart';
import 'package:grocery_shopping/app/styles/fonts.dart';
import 'package:grocery_shopping/app/styles/ui_helpers.dart';
import 'package:grocery_shopping/core/constants/app_assets.dart';
import 'package:grocery_shopping/core/constants/spacing.dart';
import 'package:grocery_shopping/data/firebase_methods.dart';
import 'package:grocery_shopping/data/order_model.dart';
import 'package:grocery_shopping/domain/providers.dart';
import 'package:grocery_shopping/features/home/data/grocery_model.dart';
import 'package:grocery_shopping/features/home/presentation/pages/homeDetail.dart';
import 'package:grocery_shopping/screens/search_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final groceries = ref.watch(fetchGroceriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: groceries.when(data: (data) {
        List<Grocery> fruits = data
            .where((element) => element.category.contains("Fruits"))
            .toList();
        List<Grocery> vegetables = data
            .where((element) => element.category.contains("Vegetables"))
            .toList();
        List<Grocery> breakFast = data
            .where((element) => element.category.contains("Breakfast"))
            .toList();
        return SizedBox(
          height: screenHeight(context),
          width: screenWidth(context),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextBody(
                              "Welcome 👋",
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                            Heading(
                              FirebaseAuth.instance.currentUser!.displayName!,
                              fontSize: 20,
                            )
                          ],
                        ),
                        const Spacer(),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: AppColors.green.withOpacity(0.3),
                              shape: BoxShape.circle),
                          padding: const EdgeInsets.all(3),
                          child: Image.asset(AppAssets.head),
                        )
                      ],
                    ),
                    gapMedium,
                    Container(
                      height: 52,
                      width: screenWidth(context),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.grey.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(25)),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: controller,
                        onFieldSubmitted: (value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(
                                query: controller.text.trim(),
                              ),
                            ),
                          );
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: SvgPicture.asset(AppAssets.search),
                            prefixIconConstraints:
                                const BoxConstraints(maxHeight: 20),
                            hintText: "Search Groceries",
                            hintStyle: TextStyle(
                                fontSize: 13,
                                fontFamily: "Poppins",
                                color: AppColors.grey.withOpacity(0.6))),
                      ),
                    ),
                    gapMedium2,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextSemiBold(
                        "Fruits",
                        color: AppColors.base,
                        fontSize: 16,
                      ),
                    ),
                    gapMedium,
                    HorizontalCard(data: fruits),
                    gapMedium2,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextSemiBold(
                        "Vegetables",
                        color: AppColors.base,
                        fontSize: 16,
                      ),
                    ),
                    gapMedium,
                    HorizontalCard(data: vegetables),
                    gapMedium2,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextSemiBold(
                        "Provisions",
                        color: AppColors.base,
                        fontSize: 16,
                      ),
                    ),
                    gapMedium,
                    HorizontalCard(data: breakFast),
                  ],
                ),
              ),
            ),
          ),
        );
      }, error: (_, __) {
        return const Text("error!");
      }, loading: () {
        return SizedBox(
          height: screenHeight(context),
          width: screenWidth(context),
          child: const Center(
            child: SpinKitChasingDots(
              color: AppColors.green,
            ),
          ),
        );
      }),
    );
  }
}

class HorizontalCard extends ConsumerStatefulWidget {
  final List<Grocery> data;

  const HorizontalCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  ConsumerState<HorizontalCard> createState() => _HorizontalCardState();
}

class _HorizontalCardState extends ConsumerState<HorizontalCard> {
  int amount = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight(context) * 0.27,
      width: screenWidth(context),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeDetail(
                      grocery: widget.data[index],
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
                      child: CachedNetworkImage(
                        imageUrl: widget.data[index].image,
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
                      ),
                    ),
                    const Spacer(),
                    TextSemiBold(
                      widget.data[index].name,
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
                        initialRating: widget.data[index].rating,
                      ),
                    ),
                    Row(
                      children: [
                        TextSemiBold(
                          "N${widget.data[index].price}",
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
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      child: Container(
                                        height: screenHeight(context) * 0.62,
                                        width: screenWidth(context),
                                        color: AppColors.white,
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0, left: 20),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: CircleAvatar(
                                                    radius: 17,
                                                    backgroundColor: AppColors
                                                        .blue
                                                        .withOpacity(0.1),
                                                    child: const Icon(
                                                      FontAwesomeIcons.x,
                                                      size: 15,
                                                      color: AppColors.base,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            SizedBox(
                                              height:
                                                  screenHeight(context) * 0.2,
                                              width: screenWidth(context),
                                              child: CachedNetworkImage(
                                                imageUrl: widget.data[index].image,
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
                                              ),
                                            ),
                                            gapSmall,
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20.0, left: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  TextSemiBold(
                                                    widget.data[index].name,
                                                    fontSize: 18,
                                                    color: AppColors.base,
                                                  ),
                                                  TextSemiBold(
                                                    "N${widget.data[index].price}",
                                                    fontSize: 18,
                                                    color: AppColors.base,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 9,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20.0, left: 20),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: RatingBar(
                                                  ratingWidget: RatingWidget(
                                                    full: const Icon(
                                                      Icons.star,
                                                      color: AppColors.green,
                                                    ),
                                                    half: const Icon(
                                                        Icons.star_half),
                                                    empty: Icon(
                                                      Icons.star,
                                                      color: AppColors.base
                                                          .withOpacity(0.2),
                                                    ),
                                                  ),
                                                  onRatingUpdate: (rating) {},
                                                  itemSize: 20,
                                                  initialRating:
                                                      widget.data[index].rating,
                                                ),
                                              ),
                                            ),
                                            gapSmall,
                                            const Divider(),
                                            gapMedium,
                                            TextBody("How many do you want"),
                                            gapMedium,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                    FontAwesomeIcons.minus,
                                                    color: AppColors.blue,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColors.base),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: Heading(
                                                      amount.toString(),
                                                      color: AppColors.base,
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
                                                    FontAwesomeIcons.plus,
                                                    color: AppColors.blue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            gapMedium,
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () async {
                                                print("here");
                                                final grocery =
                                                    widget.data[index];
                                                await ref
                                                    .read(firebaseProvider)
                                                    .addToCart(Cart(
                                                        image: grocery.image,
                                                        price: grocery.price
                                                            .round(),
                                                        name: grocery.name,
                                                        amount: amount));
                                                if (mounted) {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: TextBody(
                                                        "Added to cart successfully",
                                                        color: AppColors.white,
                                                      ),
                                                      backgroundColor:
                                                          Colors.green,
                                                      duration: const Duration(
                                                          milliseconds: 600),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                height: 56,
                                                width: screenWidth(context),
                                                decoration: const BoxDecoration(
                                                    color: AppColors.green),
                                                child: Center(
                                                  child: TextSemiBold(
                                                    "Add to cart",
                                                    color: AppColors.white,
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
            ),
          );
        },
        separatorBuilder: (_, __) {
          return gapMedium;
        },
        itemCount: widget.data.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
