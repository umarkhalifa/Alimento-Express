import 'package:flutter/material.dart';
import 'package:grocery_shopping/app/styles/app_colors.dart';
import 'package:grocery_shopping/app/styles/ui_helpers.dart';

class InputForm extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? isPassword;
  final String hint;
  final Function? onPress;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? hintColor;
  final VoidCallback? updateVisibility;

  const InputForm(
      {Key? key,
      required this.controller,
      required this.validator,
      required this.hint,
      this.isPassword,
      this.onPress,
      this.icon, this.backgroundColor, this.hintColor, this.updateVisibility})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: screenWidth(context),
      decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.accent,
          borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: TextFormField(
          controller: controller,
          obscureText: isPassword ?? false,
          cursorColor: AppColors.green,
          decoration: InputDecoration(
            suffixIcon: isPassword != null
                ? IconButton(
                    onPressed: isPassword != null ? updateVisibility! : (){},
                    icon: Icon(
                      isPassword! ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.grey,
                    ),
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(maxHeight: 25,minWidth: 40),
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
              color: hintColor ?? AppColors.base.withOpacity(0.8),
              fontFamily: "Poppins",
              fontSize: 13
            ),
          ),
          validator: validator,
        ),
      ),
    );
  }
}
