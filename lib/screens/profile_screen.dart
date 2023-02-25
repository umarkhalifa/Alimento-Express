import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_shopping/app/styles/app_colors.dart';
import 'package:grocery_shopping/app/styles/fonts.dart';
import 'package:grocery_shopping/app/styles/ui_helpers.dart';
import 'package:grocery_shopping/core/constants/app_assets.dart';
import 'package:grocery_shopping/core/constants/spacing.dart';
import 'package:grocery_shopping/core/controllers/request_view_model.dart';
import 'package:grocery_shopping/core/validation_extensions.dart';
import 'package:grocery_shopping/domain/providers.dart';
import 'package:grocery_shopping/domain/view_models/updateInfo.dart';
import 'package:grocery_shopping/features/auth/presentation/widgets/form_field.dart';
import 'package:uuid/uuid.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    passwordController = TextEditingController();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderProvider);
    return Scaffold(
      appBar: AppBar(
        title: TextSemiBold(
          "Order History",
          color: AppColors.base,
          fontSize: 20,
        ),
        leading: GestureDetector(
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
          child: const Icon(
            FontAwesomeIcons.arrowRightFromBracket,
            color: AppColors.base,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: orders.when(
          data: (data) {

            return data.docs.isNotEmpty ? ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                    height: screenHeight(context) * 0.25,
                    width: screenWidth(context),
                    color: AppColors.white,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: screenHeight(context) * 0.1,
                              width: screenWidth(context) * 0.3,
                              child: CachedNetworkImage(
                                imageUrl: data.docs[index].data()['image'],
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
                            gapMedium,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                gapMedium,
                                TextSemiBold(
                                  data.docs[index].data()['name'],
                                  color: AppColors.base,
                                  fontSize: 16,
                                ),
                                TextBody(
                                  "${data.docs[index].data()['AMOUNT']} items",
                                  color: AppColors.grey,
                                  fontSize: 13,
                                )
                              ],
                            ),
                          ],
                        ),
                        gapMedium,
                        Row(
                          children: [
                            gapMedium,
                            gapSmall,
                            TextBody(
                              "ID Order:",
                              color: AppColors.grey,
                            ),
                            const Spacer(),
                            TextSemiBold(
                              "#${Uuid().v4().substring(0, 8)}",
                              color: AppColors.base,
                            )
                          ],
                        ),
                        gapSmall,
                        Row(
                          children: [
                            gapMedium,
                            gapSmall,
                            TextBody(
                              "Total Price:",
                              color: AppColors.grey,
                            ),
                            const Spacer(),
                            TextSemiBold(
                              "${data.docs[index].data()['AMOUNT'] * data.docs[index].data()['price']}",
                              color: AppColors.base,
                            )
                          ],
                        ),
                        gapSmall,
                        Row(
                          children: [
                            gapMedium,
                            gapSmall,
                            TextBody(
                              "Status:",
                              color: AppColors.grey,
                            ),
                            const Spacer(),
                            TextSemiBold(
                              data.docs[index].data()['status']
                                  ? "Processed"
                                  : "Waiting",
                              color: data.docs[index].data()['status']
                                  ? AppColors.green
                                  : Colors.orange,
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) {
                  return gapMedium;
                },
                itemCount: data.docs.length) : SizedBox(
              height: screenHeight(context),
              width: screenWidth(context),
              child: Center(
                child: TextSemiBold("No orders yet",color: AppColors.base,),
              ),

            );
          },
          error: (_, __) {},
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
          }),
    );
  }
}
