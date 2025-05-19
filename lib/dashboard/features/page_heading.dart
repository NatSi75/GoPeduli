import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/helper/size.dart';

class GoPeduliHeading extends StatelessWidget {
  const GoPeduliHeading(
      {super.key, required this.heading, this.rightSideWidget});

  final String heading;
  final Widget? rightSideWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(heading,
              style: const TextStyle(fontSize: GoPeduliSize.fontSizeTitle)),
          rightSideWidget ?? const SizedBox(),
        ],
      ),
    );
  }
}
