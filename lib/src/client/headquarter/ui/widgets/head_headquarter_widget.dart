import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/widgets/button_top_widget.dart';
import 'package:ponte_glam/src/client/headquarter/ui/widgets/like_icon_widget.dart';

class HeaderHeadquarterDetail extends StatefulWidget {
  const HeaderHeadquarterDetail({
    super.key,
    required this.width,
    required this.height,
    required this.headquarter,
  });

  final double width;
  final double height;
  final HeadquarterModel headquarter;

  @override
  State<HeaderHeadquarterDetail> createState() =>
      _HeaderHeadquarterDetailState();
}

class _HeaderHeadquarterDetailState extends State<HeaderHeadquarterDetail> {
  late HeadquarterModel headquarter;
  late double width;
  late double height;

  @override
  void initState() {
    headquarter = widget.headquarter;
    width = widget.width;
    height = widget.height;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(rounded10),
              child: Hero(
                tag:
                    "${headquarter.id}${headquarter.imageUrl}${headquarter.name}",
                child: ImageLoadWidget(
                    image: headquarter.imageUrl,
                    fit: BoxFit.cover,
                    typeSourceImage: TypeSourceImage.network),
              ),
            )),
            Positioned.fill(
                child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(rounded10)),
                  gradient: LinearGradient(colors: [
                    Colors.black,
                    Colors.black45,
                    Colors.black26,
                    Colors.black26,
                    Colors.black12
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
            )),
            ButtonTopWidget(
                icon: iconBackArrow,
                left: 10,
                onTap: () {
                  Navigator.pop(context);
                }),
            ButtonTopWidget(
                rigth: 10,
                child: LikeInteraction(
                  padding: const EdgeInsets.all(8.0),
                  isLoading: false,
                  headquarter: headquarter,
                  color: Colors.white,
                )),
            _buildPositionedTitle()
          ],
        ),
      ),
    );
  }

  Positioned _buildPositionedTitle() {
    return Positioned(
        left: 0,
        bottom: 10,
        width: width * .95,
        height: 60,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${headquarter.companyInfo?.name ?? ''} (${headquarter.name})",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: h3Size,
                      fontFamily: fontFamilyMontserrat,
                      fontWeight: FontWeight.bold,
                      color: whiteColorTheme),
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: Container(
                  height: 30,
                  width: (width * .95) / 2,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(rounded28),
                      border: Border.all(color: whiteColorTheme)),
                  child: Text(
                    headquarter.address ??
                        getIt<AppLocalizations>().failureNoFound(""),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: h5Size,
                        fontFamily: fontFamilyMontserrat,
                        fontWeight: FontWeight.bold,
                        color: whiteColorTheme),
                  ),
                )),
          ],
        ));
  }
}
