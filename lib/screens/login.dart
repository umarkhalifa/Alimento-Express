import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_shopping/app/styles/app_colors.dart';
import 'package:grocery_shopping/app/styles/app_gradients.dart';
import 'package:grocery_shopping/app/styles/fonts.dart';
import 'package:grocery_shopping/app/styles/ui_helpers.dart';
import 'package:grocery_shopping/core/constants/app_assets.dart';
import 'package:grocery_shopping/core/constants/spacing.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grocery_shopping/core/controllers/request_view_model.dart';
import 'package:grocery_shopping/core/navigators/route_names.dart';
import 'package:grocery_shopping/core/validation_extensions.dart';
import 'package:grocery_shopping/domain/view_models/login_view_model.dart';
import 'package:grocery_shopping/features/auth/presentation/widgets/form_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool visible = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: screenHeight(context),
              width: screenWidth(context),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.asset(AppAssets.logo),
                        ),
                        gapMedium,
                        Heading(
                          "Alimento ",
                          color: AppColors.base,
                        ),
                        Heading(
                          "Express",
                          color: AppColors.green,
                        ),
                      ],
                    ),
                    gapMassive,
                    TextSemiBold(
                      "Welcome Back",
                      color: AppColors.base,
                      fontSize: 28,
                    ),
                    gapMedium,
                    InputForm(
                      controller: emailController,
                      validator: context.validateEmailAddress,
                      hint: "Email address",
                      icon: SvgPicture.asset(AppAssets.email),
                      backgroundColor: AppColors.grey.withOpacity(0.1),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    InputForm(
                      controller: passwordController,
                      validator: context.validatePassword,
                      hint: "Password",
                      icon: SvgPicture.asset(AppAssets.lock),
                      backgroundColor: AppColors.grey.withOpacity(0.1),
                      isPassword: visible,
                      updateVisibility: (){
                        visible = !visible;
                        setState(() {
                        });
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Consumer(
                      builder:
                          (BuildContext context, WidgetRef ref, Widget? child) {
                        final signUp = ref.watch(loginVMProvider);
                        ref.listen(loginVMProvider, (previous, next) {
                          if (next is Error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: TextBody(
                                  next.error.toString(),
                                  color: AppColors.white,
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else if (next is Success) {
                            Navigator.pushNamed(context, Routes.homeNav);
                          }
                        });
                        return GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              ref.read(loginVMProvider.notifier).login(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );
                            }
                          },
                          child: Container(
                            height: 52,
                            width: screenWidth(context) * 0.45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.green,
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.base.withOpacity(0.2),
                                    offset: const Offset(0, 3),
                                    blurRadius: 10)
                              ],
                            ),
                            child: Center(
                              child: signUp is Loading == false
                                  ? TextSemiBold("Sign In")
                                  : const CircularProgressIndicator(
                                      color: AppColors.white,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        TextBody("Create new account?  "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.signup);
                          },
                          child: TextBody(
                            "Sign Up",
                            color: AppColors.green,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          size: 15,
                          color: AppColors.green,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
