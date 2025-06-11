import 'package:flutter/material.dart';
import 'package:gopeduli/dashboard/features/rounded_container.dart';
import 'package:gopeduli/dashboard/features/section_heading.dart';
import 'package:gopeduli/dashboard/helper/color.dart';
import 'package:gopeduli/dashboard/helper/size.dart';
import 'package:material_symbols_icons/symbols.dart';

class GoPeduliDashboardCard extends StatelessWidget {
  const GoPeduliDashboardCard(
      {super.key,
      required this.title,
      required this.subTitle,
      this.icon = Symbols.arrow_upward_rounded,
      this.color = Colors.green,
      required this.stats,
      this.comparisonText = '',
      this.onTap});

  final String title, subTitle;
  final IconData icon;
  final Color color;
  final int stats;
  final String comparisonText;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GoPeduliRoundedContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(
        GoPeduliSize.paddingHeightSmall,
      ),
      child: Column(
        children: [
          // Heading
          GoPeduliSectionHeading(
            title: title,
            textColor: GoPeduliColors.secondary,
          ),
          const SizedBox(height: GoPeduliSize.sizedBoxHeightSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subTitle,
                style: const TextStyle(fontSize: GoPeduliSize.fontSizeBody),
              ),

              // Right Side Stats
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Indicator
                  SizedBox(
                    child: Row(
                      children: [
                        Icon(icon, color: color),
                        Text(
                          ' $stats%',
                          style: Theme.of(context).textTheme.titleMedium!.apply(
                              color: color, overflow: TextOverflow.ellipsis),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: Text(
                      comparisonText,
                      style: Theme.of(context).textTheme.labelSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
