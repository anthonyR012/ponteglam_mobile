import 'package:flutter/cupertino.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/amenity_model.dart';
import 'package:ponte_glam/shared/widgets/amenity_card_widget.dart';

class AmenitiesSectionDetail extends StatelessWidget {
  const AmenitiesSectionDetail(
      {super.key, required this.width, required this.amenities});
  final double width;
  final List<int> amenities;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(paddingInput15),
      color: whiteColorTheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const _AmenityTitle(),
          _LateralListAmenities(amenities: amenities, width: width)
        ],
      ),
    );
  }
}

class _AmenityTitle extends StatelessWidget {
  const _AmenityTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      getIt<AppLocalizations>().titleAmenities,
      textAlign: TextAlign.start,
      style: const TextStyle(
          fontFamily: fontFamilyMontserrat,
          color: blackColorTheme,
          fontWeight: FontWeight.bold,
          fontSize: h3Size),
    );
  }
}

class _LateralListAmenities extends StatefulWidget {
  const _LateralListAmenities({
    required this.amenities,
    required this.width,
  });

  final List<int> amenities;
  final double width;

  @override
  State<_LateralListAmenities> createState() => _LateralListAmenitiesState();
}

class _LateralListAmenitiesState extends State<_LateralListAmenities> {
  @override
  void initState() {
    context.read<SettingBloc>().add(DoGetAmenitiesEvent(
        idAmenities: widget.amenities));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: BlocBuilder<SettingBloc, SettingState>(
        buildWhen: (previous, current) => current is GetAmenitiesLoaded,
        builder: (context, state) {
          bool isLoading = state is SettingIsLoading;
          List<AmenityModel> amenities =
              state is GetAmenitiesLoaded ? state.amenities : [];
          return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
                  List.generate(isLoading ? 4 : amenities.length, (index) {
                return AmenityCard(
                  width: widget.width,
                  isLoading: isLoading,
                  description: isLoading ? '_' : amenities[index].description,
                  icon: isLoading ? '_' : amenities[index].iconName,
                );
              }));
        },
      ),
    );
  }
}
