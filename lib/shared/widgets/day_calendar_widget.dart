import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DayCalendarCard extends StatefulWidget {
  const DayCalendarCard(
      {super.key,
      required this.width,
      required this.numberDay,
      required this.day,
      required this.onTap,
      required this.isSelected,
      required this.isLoading});

  final double width;
  final String numberDay;
  final String day;
  final bool isLoading;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<DayCalendarCard> createState() => _DayCalendarCardState();
}

class _DayCalendarCardState extends State<DayCalendarCard> {
  @override
  Widget build(BuildContext context) {
    final double widthCard = widget.width * .13;
    return Skeleton.shade(
      shade: widget.isLoading,
      child: InkWell(
        onTap: widget.onTap,
        splashFactory: InkSparkle.splashFactory,
        child: Container(
          width: widthCard,
          height: widget.width * .18,
          margin: const EdgeInsets.all(paddingInput5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(rounded10),
            color: widget.isSelected
                ? secondaryColorTheme
                : linearColorTheme.withValues(alpha: 0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.isLoading
                  ? const Skeleton.leaf(child: CircleAvatar())
                  : Text(widget.numberDay,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: widget.isSelected
                            ? whiteColorTheme
                            : secondaryColorTheme,
                        fontFamily: fontFamilyHind,
                        fontWeight: FontWeight.bold,
                        fontSize: h2Size - 2,
                      )),
              const SizedBox(width: spaceBetween10 + 5),
              SizedBox(
                width: widthCard * 0.6,
                child: Text(widget.isLoading ? "_" * 4 : widget.day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.isSelected
                          ? whiteColorTheme
                          : secondaryColorTheme,
                      fontFamily: fontFamilyHind,
                      fontSize: h5Size + 2,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
