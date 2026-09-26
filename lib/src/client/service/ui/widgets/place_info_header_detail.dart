import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:ponte_glam/src/client/headquarter/ui/headquarter_detail_page.dart';
import 'package:ponte_glam/src/client/rate/ui/ratings_page.dart';

class PlaceInfoHeader extends StatelessWidget {
  const PlaceInfoHeader({
    super.key,
    required this.headquarter,
    this.service,
  });
  final HeadquarterModel headquarter;
  final ServiceModel? service;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    headquarter.name,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontFamily: fontFamilyMontserrat,
                        color: blackColorTheme,
                        fontWeight: FontWeight.bold,
                        fontSize: h3Size),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(17),
                  onTap: () => context.pushNamed(
                    HeadquarterDetailPage.routeName,
                    extra: headquarter,
                  ),
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: primaryColorTheme,
                    child: SvgPicture.asset(
                      '$pathManagementIcons$iconBuilding',
                      colorFilter: const ColorFilter.mode(
                          whiteColorTheme, BlendMode.srcIn),
                      width: 18,
                      height: 18,
                    ),
                  ),
                ),
                if (headquarter.phoneNumber != null &&
                    headquarter.phoneNumber!.isNotEmpty) ...[
                  const SizedBox(width: spaceBetween10),
                  BlocListener<ServiceBloc, ServiceState>(
                    listenWhen: (previous, current) =>
                        current is MakeCallSuccess || current is MakeCallError,
                    listener: (context, state) {
                      if (state is MakeCallError) {
                        PonteSnackBar.show(
                          context,
                          message: state.message,
                          type: TypeAlert.error,
                        );
                      }
                    },
                    child: InkWell(
                      borderRadius: BorderRadius.circular(17),
                      onTap: () => getIt<ServiceBloc>().add(
                          MakeCallServiceEvent(
                              phoneNumber: headquarter.phoneNumber!)),
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: primaryColorTheme,
                        child: SvgPicture.asset(
                          '$pathManagementIcons$iconCall',
                          colorFilter: const ColorFilter.mode(
                              whiteColorTheme, BlendMode.srcIn),
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: spaceBetween10 * 1.5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  '$pathManagementIcons$iconStartComplete',
                  colorFilter: const ColorFilter.mode(
                      primaryColorTheme, BlendMode.srcIn),
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  "${headquarter.rating} (${headquarter.ratingCount} ${getIt<AppLocalizations>().titleReviews})",
                  style: const TextStyle(
                      color: grayTextColorTheme,
                      fontFamily: fontFamilyMontserrat,
                      fontSize: minimalMonserratSize),
                ),
                const Spacer(),
                if (service != null) _ViewRatingsButton(service: service!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewRatingsButton extends StatelessWidget {
  const _ViewRatingsButton({required this.service});
  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RatingsPage(
            serviceId: service.id,
            serviceName: service.name,
            canReview: service.canRate,
            myRating: service.myRating,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: primaryColorTheme.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColorTheme.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_half_rounded,
                color: primaryColorTheme, size: 14),
            const SizedBox(width: 4),
            Text(
              getIt<AppLocalizations>().titleViewRatings,
              style: const TextStyle(
                color: primaryColorTheme,
                fontFamily: fontFamilyMontserrat,
                fontSize: minimalMonserratSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
