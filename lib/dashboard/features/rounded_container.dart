import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';

class GoPeduliRoundedContainer extends StatelessWidget {
  const GoPeduliRoundedContainer(
      {super.key,
      this.child,
      this.radius = 10.0,
      this.width,
      this.height,
      this.showBorder = true,
      this.showShadow = false,
      this.borderColor = GoPeduliColors.primary,
      this.margin,
      this.padding = const EdgeInsets.all(GoPeduliSize.paddingHeightSmall),
      this.backgroundColor = Colors.white,
      this.onTap});

  final Widget? child;
  final double radius;
  final double? width;
  final double? height;
  final bool showBorder;
  final bool showShadow;
  final Color borderColor;
  final EdgeInsets? margin;
  final EdgeInsets padding;
  final Color backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius),
          border: showBorder ? Border.all(color: borderColor) : null,
          boxShadow: [
            if (showShadow)
              BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 8,
                  spreadRadius: 5,
                  offset: const Offset(0, 3))
          ],
        ),
        child: child,
      ),
    );
  }
}
