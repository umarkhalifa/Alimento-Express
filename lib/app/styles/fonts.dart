import 'package:flutter/material.dart';
import 'package:grocery_shopping/app/styles/app_colors.dart';

class CurrencyTextBase extends StatelessWidget {
  const CurrencyTextBase(
    this.text, {
    this.style,
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.visible,
    this.maxLines = 1,
    Key? key,
    this.softWrap,
  }) : super(key: key);
  final String? text;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int maxLines;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    assert(text != null, 'test can not be null');
    return Text(
      text ?? '',
      style:const TextStyle(
          fontSize: 14,
          color: AppColors.base,
        fontFamily: "Poppins"
        ).merge(style),
      textAlign: textAlign,
      overflow: overflow,
      softWrap: softWrap,
      maxLines: maxLines,
    );
  }
}

class Heading extends CurrencyTextBase {
  Heading(
    String text, {
    Key? key,
    Color? color,
    TextStyle? style,
    double? fontSize,
    FontWeight fontWeight = FontWeight.w800,
    TextAlign textAlign = TextAlign.left,
    TextOverflow overflow = TextOverflow.visible,
    int maxLines = 3,
  }) : super(
          text,
          key: key,
          overflow: overflow,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: fontSize ?? 24,
            fontWeight: fontWeight,
            color: color ?? AppColors.base,
          ).merge(style),
          textAlign: textAlign,
        );
}

class TextBody extends CurrencyTextBase {
  TextBody(
    String text, {
    Key? key,
    TextStyle? style,
    Color? color,
    double? fontSize,
    TextAlign textAlign = TextAlign.left,
    bool softWrap = false,
    FontWeight fontWeight = FontWeight.w400,
    TextOverflow overflow = TextOverflow.visible,
    int maxLines = 2,
    double? height,
  }) : super(
          text,
          key: key,
          overflow: overflow,
          maxLines: maxLines,
          softWrap: softWrap,
          style: TextStyle(
            fontSize: fontSize ?? 14,
            color: color ?? AppColors.base,
            fontWeight: fontWeight,
            height: height,
          ).merge(style),
          textAlign: textAlign,
        );
}

class TextSemiBold extends CurrencyTextBase {
  TextSemiBold(
    String text, {
    Key? key,
    TextStyle? style,
    double? fontSize,
    Color? color,
    FontWeight fontWeight = FontWeight.w500,
    TextAlign textAlign = TextAlign.left,
    TextOverflow overflow = TextOverflow.visible,
    int maxLines = 2,
  }) : super(
          text,
          key: key,
          overflow: overflow,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: fontSize ?? 14,
            color: color ?? AppColors.white,
            fontWeight: fontWeight,
          ).merge(style),
          textAlign: textAlign,
        );
}
