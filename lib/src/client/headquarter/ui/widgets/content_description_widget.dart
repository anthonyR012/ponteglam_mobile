import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';

class ContentDescriptionDetail extends StatefulWidget {
  const ContentDescriptionDetail({super.key, required this.headquarter});
  final HeadquarterModel headquarter;

  @override
  State<ContentDescriptionDetail> createState() =>
      _ContentDescriptionDetailState();
}

class _ContentDescriptionDetailState extends State<ContentDescriptionDetail> {
  bool isExpanded = false;
  Color expandedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              getIt<AppLocalizations>().questionWhoAreWe,
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontFamily: fontFamilyMontserrat,
                  color: blackColorTheme,
                  fontWeight: FontWeight.bold,
                  fontSize: h3Size),
            ),
            const Spacer(),
            if (widget.headquarter.phoneNumber != null &&
                widget.headquarter.phoneNumber!.isNotEmpty) ...[
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
                  onTap: () => getIt<ServiceBloc>().add(MakeCallServiceEvent(
                      phoneNumber: widget.headquarter.phoneNumber!)),
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
        const SizedBox(height: spaceBetween10),
        Text(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et do... Show More" *
              3,
          maxLines: isExpanded ? null : (maxLinesSize + 1),
          overflow: isExpanded ? null : TextOverflow.ellipsis,
          style: const TextStyle(
            color: blackColorTheme,
            fontFamily: fontFamilyHind,
            fontSize: messageSize,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                  expandedColor = isExpanded ? Colors.grey : Colors.blue;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  isExpanded ? 'Ver menos' : 'Ver más',
                  style: TextStyle(
                    color: expandedColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: spaceBetween10),
      ],
    );
  }
}
