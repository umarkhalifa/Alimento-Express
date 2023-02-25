import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_shopping/domain/providers.dart';
import 'package:grocery_shopping/features/auth/presentation/pages/onboarding_screen.dart';
import 'package:grocery_shopping/features/home/presentation/homeNav.dart';
class AuthStatus extends ConsumerWidget {
  const AuthStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(authStatusProvider);
    if(status.value == null){
      return const OnBoardingScreen();
    }else{
      return const HomeNavigationBar();
    }
  }
}
