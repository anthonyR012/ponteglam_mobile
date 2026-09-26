import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/shared/widgets/rating_builder_widget.dart';
import 'package:ponte_glam/shared/widgets/rating_indicator_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RatingBarWidget extends StatelessWidget {
  const RatingBarWidget(
      {super.key,
      required this.isLoading,
      required this.rating,
      this.justIndicator = true,
      this.onRatingUpdate});
  final bool isLoading;
  final bool justIndicator;
  final double rating;
  final void Function(double)? onRatingUpdate;

  @override
  Widget build(BuildContext context) {
    return Skeleton.shade(
        shade: isLoading,
        child: justIndicator
            ? RatingBarIndicator(
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 15,
                rating: rating,
                itemBuilder: (context, index) {
                  return SvgPicture.asset(
                    '$pathManagementIcons$iconStartComplete',
                    colorFilter: const ColorFilter.mode(
                        primaryColorTheme, BlendMode.srcIn),
                  );
                },
                itemPadding: EdgeInsets.zero,
              )
            : RatingBar(
                initialRating: rating,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 15,
                ratingWidget: RatingWidget(
                  full: SvgPicture.asset(
                    '$pathManagementIcons$iconStartComplete',
                    colorFilter: const ColorFilter.mode(
                        primaryColorTheme, BlendMode.srcIn),
                  ),
                  half: SvgPicture.asset(
                    '$pathManagementIcons$iconStartHalf',
                    colorFilter: const ColorFilter.mode(
                        primaryColorTheme, BlendMode.srcIn),
                  ),
                  empty: SvgPicture.asset(
                    '$pathManagementIcons$iconStartEmpty',
                    colorFilter: const ColorFilter.mode(
                        primaryColorTheme, BlendMode.srcIn),
                  ),
                ),
                itemPadding: EdgeInsets.zero,
                onRatingUpdate: onRatingUpdate!,
              ));
  }
}
