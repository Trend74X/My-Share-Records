import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final double elevation;
  final Color? color;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? fontColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderSide? borderside;
  TextStyle? style;

  CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
    this.width,
    this.elevation = 0.0,
    this.color,
    this.borderRadius = 100,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.fontColor = Colors.white,
    this.fontSize,
    this.fontWeight, 
    this.style, this.borderside,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      width: width ?? 320,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: elevation,
          textStyle: TextStyle(
            color: fontColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          animationDuration: const Duration(milliseconds: 200),
          shadowColor: Colors.transparent,
          side: borderside ?? BorderSide.none,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: fontColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}