import 'package:flutter/material.dart';

class GoPeduliAnimationLoaderWidget extends StatelessWidget {
  const GoPeduliAnimationLoaderWidget({
    super.key,
    required this.text,
    this.style,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
    this.height,
    this.width,
  });

  final String text;
  final TextStyle? style;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            text,
            style: style ?? const TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(
            height: 20,
          ),
          showAction
              ? SizedBox(
                  width: 200,
                  child: OutlinedButton(
                    onPressed: onActionPressed,
                    child: Text(actionText ?? 'Action'),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
