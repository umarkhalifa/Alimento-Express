import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_shopping/app/styles/app_colors.dart';
import 'package:grocery_shopping/app/styles/fonts.dart';
import 'package:grocery_shopping/app/styles/ui_helpers.dart';
import 'package:grocery_shopping/core/constants/spacing.dart';
import 'package:grocery_shopping/core/validation_extensions.dart';
import 'package:grocery_shopping/data/firebase_methods.dart';
import 'package:grocery_shopping/data/order_model.dart';
import 'package:grocery_shopping/data/paymen.dart';
import 'package:grocery_shopping/domain/providers.dart';
import 'package:grocery_shopping/features/auth/presentation/widgets/form_field.dart';
import 'package:grocery_shopping/features/home/data/grocery_model.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(
    BuildContext context,
  ) {
    final cart = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(
        title: Heading(
          "Cart",
          color: AppColors.base,
          fontSize: 20,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: cart.when(data: (data) {
        num getAmount() {
          num amount = 0;
          for (var element
          in data.docs) {
            amount += (element
                .data()[
            'amount'] *
                element.data()[
                'price']);
          }
          return amount;
        }
        return data.docs.isNotEmpty
            ? SingleChildScrollView(
                child: SafeArea(
                  child: SizedBox(
                    height: screenHeight(context),
                    width: screenWidth(context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              final cart = Cart(
                                  image: data.docs[index].data()['image'],
                                  price: data.docs[index].data()['price'],
                                  name: data.docs[index].data()['name'],
                                  amount: data.docs[index].data()['amount']);
                              return Container(
                                height: screenHeight(context) * 0.13,
                                width: screenWidth(context),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: screenHeight(context),
                                      width: screenWidth(context) * 0.25,
                                      child: CachedNetworkImage(
                                        imageUrl: cart.image,
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
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Heading(
                                                cart.name,
                                                color: AppColors.base,
                                                fontSize: 16,
                                              ),
                                              const Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  ref
                                                      .read(firebaseProvider)
                                                      .deleteCartItem(
                                                          data.docs[index].id);
                                                },
                                                child: Container(
                                                  height: 15,
                                                  width: 15,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                      color: AppColors.base,
                                                    ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 10,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              Heading(
                                                "N${cart.price}",
                                                color: AppColors.green,
                                                fontSize: 16,
                                              ),
                                              const Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  ref
                                                      .read(firebaseProvider)
                                                      .decrementCart(
                                                          data.docs[index].id);
                                                },
                                                child: const CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor:
                                                      AppColors.green,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        AppColors.white,
                                                    radius: 10.5,
                                                    child: Icon(
                                                      Icons.remove,
                                                      size: 15,
                                                      color: AppColors.base,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              gapSmall,
                                              TextBody(
                                                cart.amount.toString(),
                                                fontSize: 13,
                                                color: AppColors.base,
                                              ),
                                              gapSmall,
                                              GestureDetector(
                                                onTap: () {
                                                  ref
                                                      .read(firebaseProvider)
                                                      .incrementCart(
                                                          data.docs[index].id);
                                                },
                                                child: const CircleAvatar(
                                                  backgroundColor:
                                                      AppColors.green,
                                                  radius: 12,
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 15,
                                                    color: AppColors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (_, __) {
                              return gapMedium;
                            },
                            itemCount: data.docs.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                        ),
                        Row(
                          children: [
                            gapSmall,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextBody(
                                  "Total Price",
                                  color: AppColors.grey,
                                ),
                                Builder(builder: (context) {
                                  num getAmount() {
                                    num amount = 0;
                                    for (var element in data.docs) {
                                      amount += (element.data()['amount'] *
                                          element.data()['price']);
                                    }
                                    return amount;
                                  }

                                  return TextSemiBold(
                                    "N${getAmount().toString()}",
                                    color: AppColors.base,
                                    fontSize: 26,
                                  );
                                })
                              ],
                            ),
                            gapMedium,
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                          child: Container(
                                            height: screenHeight(context) * 0.8,
                                            color: AppColors.white,
                                            padding: const EdgeInsets.all(15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                gapMassive,
                                                TextSemiBold(
                                                  "Order Confirmation",
                                                  fontSize: 19,
                                                  color: AppColors.base,
                                                ),
                                                gapMedium,
                                                Container(
                                                  height: 60,
                                                  width: screenWidth(context),
                                                  decoration: BoxDecoration(
                                                      color: AppColors.grey
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        FontAwesomeIcons.paypal,
                                                        color: AppColors.green,
                                                      ),
                                                      gapMedium,
                                                      TextSemiBold(
                                                        "PayPal",
                                                        color: AppColors.green,
                                                      ),
                                                      const Spacer(),
                                                      Checkbox(
                                                        value: true,
                                                        activeColor:
                                                            Colors.white,
                                                        onChanged: (value) {},
                                                        checkColor:
                                                            AppColors.green,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                gapMedium,
                                                TextBody(
                                                  "Delivery Address",
                                                  color: AppColors.grey,
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                InputForm(
                                                  controller: controller,
                                                  validator: context
                                                      .validateFieldNotEmpty,
                                                  hint: "Delivery Address",
                                                  backgroundColor: AppColors
                                                      .grey
                                                      .withOpacity(0.2),
                                                ),
                                                gapMedium,
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextBody(
                                                      "Estimated Delivery Time",
                                                      color: AppColors.grey,
                                                    ),
                                                    TextBody(
                                                      "2 - 3 hours",
                                                      color: AppColors.base,
                                                    )
                                                  ],
                                                ),
                                                const Spacer(),
                                                Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        TextBody(
                                                          "Total Price",
                                                          color: AppColors.grey,
                                                        ),
                                                        Builder(
                                                            builder: (context) {


                                                          return TextSemiBold(
                                                            "N${getAmount().toString()}",
                                                            color:
                                                                AppColors.base,
                                                            fontSize: 26,
                                                          );
                                                        })
                                                      ],
                                                    ),
                                                    gapMedium,
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          Payment(
                                                              price: int.parse(getAmount().toString()),
                                                              context: context,
                                                              email: "${FirebaseAuth.instance.currentUser!.email}",
                                                               ref: ref)
                                                              .chargeCard();
                                                        },
                                                        child: Container(
                                                          height: 52,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                AppColors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: Center(
                                                            child: TextSemiBold(
                                                              "Place Order",
                                                              color: AppColors
                                                                  .white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  height: 52,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  decoration: BoxDecoration(
                                      color: AppColors.green,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: TextSemiBold(
                                      "CheckOut",
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            gapMedium,
                          ],
                        ),
                        gapMassive,
                        gapMassive,
                        gapLarge,
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: screenHeight(context),
                width: screenWidth(context),
                child: Center(
                  child: TextSemiBold(
                    "Cart is Empty",
                    color: AppColors.base,
                  ),
                ),
              );
      }, error: (_, __) {
        return const Text("error");
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
