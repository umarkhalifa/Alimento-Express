import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_shopping/app/styles/app_colors.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:grocery_shopping/core/constants/app_assets.dart';
import 'package:grocery_shopping/screens/cart_screen.dart';
import 'package:grocery_shopping/screens/home_screen.dart';
import 'package:grocery_shopping/screens/profile_screen.dart';

final homeIndex = StateProvider.autoDispose((ref) => 0);

class HomeNavigationBar extends ConsumerWidget {
  const HomeNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = [
      const HomeScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];
    final currentIndex = ref.watch(homeIndex);
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: tabs[currentIndex],
      bottomNavigationBar: DotNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          ref.read(homeIndex.notifier).state = value;
        },
        selectedItemColor: AppColors.orange,
        items: [
          DotNavigationBarItem(
            icon: SvgPicture.asset(
              AppAssets.homeFill,
              color: currentIndex == 0
                  ? AppColors.green
                  : AppColors.base.withOpacity(0.4),
            ),
          ),
          DotNavigationBarItem(
              icon: const Icon(FontAwesomeIcons.basketShopping),
              unselectedColor: AppColors.base.withOpacity(0.4),
              selectedColor: AppColors.green),
          DotNavigationBarItem(
            icon: SvgPicture.asset(
              AppAssets.personFill,
              color: currentIndex == 2
                  ? AppColors.green
                  : AppColors.base.withOpacity(0.4),
            ),
          ),
        ],
        enableFloatingNavBar: false,
        dotIndicatorColor: AppColors.green,
        paddingR: const EdgeInsets.all(0),
        itemPadding: const EdgeInsets.symmetric(horizontal: 20),
        marginR: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
      ),
    );
  }
}
