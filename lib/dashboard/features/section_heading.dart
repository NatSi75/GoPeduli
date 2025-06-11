import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/helper/size.dart';

class GoPeduliSectionHeading extends StatelessWidget {
  const GoPeduliSectionHeading(
      {super.key, this.textColor, this.rightSideWidget, required this.title});

  final Color? textColor;
  final Widget? rightSideWidget;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: GoPeduliSize.fontSizeSubtitle),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (rightSideWidget != null) rightSideWidget!,
      ],
    );
  }
}
