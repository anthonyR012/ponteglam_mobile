import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/shared/widgets/button_top_widget.dart';
import 'package:ponte_glam/shared/widgets/day_calendar_widget.dart';
import 'package:ponte_glam/shared/widgets/icon_custom_widget.dart';
import 'package:ponte_glam/shared/widgets/rating_builder_widget.dart';
import 'package:ponte_glam/shared/widgets/title_banner_label_widget.dart';

class BottonFilterWidget extends StatefulWidget {
  const BottonFilterWidget({
    super.key,
  });

  @override
  State<BottonFilterWidget> createState() => _BottonFilterWidgetState();
}

class _BottonFilterWidgetState extends State<BottonFilterWidget> {
  late FilterServiceModel tempFilter;

  @override
  void initState() {
    super.initState();
    tempFilter = getIt<ServiceBloc>().filterService;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final ServiceBloc serviceBloc = getIt<ServiceBloc>();
    return Container(
      width: width,
      height: height * .95,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: const _GetHeaderAlert(),
          ),
          Positioned.fill(
            top: 80,
            bottom: 100,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  GetBannerTitleLabel(
                      title: getIt<AppLocalizations>().titleStoreFeature),
                  _GetStoreFilterAlert(
                    width: width,
                    filter: tempFilter,
                    onChanged: (newFilter) =>
                        setState(() => tempFilter = newFilter),
                  ),
                  const Divider(indent: 16, endIndent: 16),
                  const SizedBox(height: 10),
                  GetBannerTitleLabel(
                      title: getIt<AppLocalizations>().titlePrice),
                  _GetRangeSlider(
                    filter: tempFilter,
                    onChanged: (newFilter) =>
                        setState(() => tempFilter = newFilter),
                  ),
                  const Divider(indent: 16, endIndent: 16),
                  const SizedBox(height: 10),
                  GetBannerTitleLabel(
                      title: getIt<AppLocalizations>().titleAvailableTime),
                  _FilterAvailableTime(
                    filter: tempFilter,
                    onChanged: (newFilter) =>
                        setState(() => tempFilter = newFilter),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      getIt<ServiceBloc>().resetFilter();
                      setState(() {
                        tempFilter = const FilterServiceModel();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(rounded10),
                        border: Border.all(color: secondaryColorTheme),
                      ),
                      child: Center(
                        child: Text(
                          getIt<AppLocalizations>().titleReset.toUpperCase(),
                          style: const TextStyle(
                            color: secondaryColorTheme,
                            fontWeight: FontWeight.bold,
                            fontSize: h5Size,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      serviceBloc.setFilter(
                        context: context,
                        rating: tempFilter.rating,
                        minPrice: tempFilter.minPrice,
                        maxPrice: tempFilter.maxPrice,
                        onlyHomeService: tempFilter.onlyHomeService,
                        nearMe: tempFilter.nearMe,
                        availableFor: tempFilter.availableFor,
                      );
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [primaryColorTheme, secondaryColorTheme],
                        ),
                        borderRadius: BorderRadius.circular(rounded10),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColorTheme.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          getIt<AppLocalizations>().titleApply.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: h4Size,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterAvailableTime extends StatefulWidget {
  const _FilterAvailableTime({required this.filter, required this.onChanged});
  final FilterServiceModel filter;
  final Function(FilterServiceModel) onChanged;

  @override
  State<_FilterAvailableTime> createState() => _FilterAvailableTimeState();
}

class _FilterAvailableTimeState extends State<_FilterAvailableTime> {
  List<Map<String, String>> days = [];

  @override
  Widget build(BuildContext context) {
    days = getIt<DateFormatUtil>().getWeekDayShrink(10, context);
    final width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(days.length, (index) {
                  final dayWeek = days[index]["dayWeek"].toString();
                  final dayNumber = days[index]["dayNumber"].toString();
                  final id = days[index]["id"].toString();
                  final isSelected = widget.filter.availableFor.contains(id);

                  return DayCalendarCard(
                    width: width,
                    isLoading: false,
                    isSelected: isSelected,
                    day: dayWeek,
                    numberDay: dayNumber,
                    onTap: () {
                      List<String> availableFor =
                          List.from(widget.filter.availableFor);
                      if (isSelected) {
                        availableFor.removeWhere((idItem) => idItem == id);
                      } else {
                        availableFor.add(id);
                      }
                      widget.onChanged(
                          widget.filter.copyWith(availableFor: availableFor));
                    },
                  );
                })),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _GetStoreFilterAlert extends StatelessWidget {
  const _GetStoreFilterAlert(
      {required this.width, required this.filter, required this.onChanged});

  final double width;
  final FilterServiceModel filter;
  final Function(FilterServiceModel) onChanged;

  @override
  Widget build(BuildContext context) {
    final double rating = filter.rating ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GetSubtitleAlert(
                    subTitle: rating == 0
                        ? getIt<AppLocalizations>().titleAnyRating
                        : getIt<AppLocalizations>().titleOverThan,
                  ),
                  const SizedBox(height: 8),
                  RatingBar.builder(
                      itemSize: 32,
                      glow: false,
                      initialRating: rating,
                      itemBuilder: (context, index) {
                        return const IconCustomWidget(
                            icon: iconStartComplete,
                            colorFilter: ColorFilter.mode(
                                primaryColorTheme, BlendMode.srcIn));
                      },
                      onRatingUpdate: (rating) {
                        onChanged(filter.copyWith(rating: rating));
                      },
                      itemCount: 5),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _GetSwitchOption(
            text: getIt<AppLocalizations>().titleNearsts,
            initialValue: filter.nearMe,
            onChanged: (value) {
              onChanged(filter.copyWith(nearMe: value));
            },
          ),
          _GetSwitchOption(
            text: getIt<AppLocalizations>().titleOnlyHomeService,
            initialValue: filter.onlyHomeService,
            onChanged: (value) {
              onChanged(filter.copyWith(onlyHomeService: value));
            },
          ),
        ],
      ),
    );
  }
}

class _GetSwitchOption extends StatefulWidget {
  const _GetSwitchOption({
    required this.text,
    required this.onChanged,
    required this.initialValue,
  });
  final String text;
  final bool initialValue;
  final Function(bool) onChanged;

  @override
  State<_GetSwitchOption> createState() => _GetSwitchOptionState();
}

class _GetSwitchOptionState extends State<_GetSwitchOption> {
  bool value = false;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _GetSwitchOption oldWidget) {
    value = widget.initialValue;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _GetSubtitleAlert(
            subTitle: widget.text,
            fontSize: h4Size,
          ),
          Switch(
            value: value,
            inactiveTrackColor: secondaryColorTheme.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.white,
            activeTrackColor: primaryColorTheme.withValues(alpha: 0.5),
            activeThumbColor: primaryColorTheme,
            onChanged: (value) {
              widget.onChanged(value);
              setState(() {
                this.value = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _GetRangeSlider extends StatefulWidget {
  const _GetRangeSlider({required this.filter, required this.onChanged});
  final FilterServiceModel filter;
  final Function(FilterServiceModel) onChanged;

  @override
  State<_GetRangeSlider> createState() => __GetRangeSliderState();
}

class __GetRangeSliderState extends State<_GetRangeSlider> {
  double min = 1000;
  double max = 1000000;
  late RangeValues _selectedRange;

  @override
  void initState() {
    _selectedRange =
        RangeValues(widget.filter.minPrice, widget.filter.maxPrice);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _GetRangeSlider oldWidget) {
    _selectedRange =
        RangeValues(widget.filter.minPrice, widget.filter.maxPrice);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    String priceMin = getIt<FormatCurrencyUtil>()
        .getPriceFormat(_selectedRange.start.toString(), context);
    String priceMax = getIt<FormatCurrencyUtil>()
        .getPriceFormat(_selectedRange.end.toString(), context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                priceMin,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColorTheme,
                  fontSize: h4Size,
                ),
              ),
              Text(
                priceMax,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColorTheme,
                  fontSize: h4Size,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RangeSlider(
            values: _selectedRange,
            activeColor: primaryColorTheme,
            inactiveColor: secondaryColorTheme.withValues(alpha: 0.3),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: 100, // More granular control
            labels: RangeLabels(priceMin, priceMax),
            onChanged: (RangeValues values) {
              setState(() {
                _selectedRange = values;
              });
              widget.onChanged(widget.filter
                  .copyWith(minPrice: values.start, maxPrice: values.end));
            },
          ),
          Center(
            child: Text(
              getIt<AppLocalizations>().titleRangePrice(priceMin, priceMax),
              style: TextStyle(
                color: secondaryColorTheme.withValues(alpha: 0.7),
                fontSize: h5Size,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GetSubtitleAlert extends StatelessWidget {
  const _GetSubtitleAlert({
    required this.subTitle,
    this.fontSize = h4Size,
  });
  final String subTitle;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Text(
        subTitle,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _GetHeaderAlert extends StatelessWidget {
  const _GetHeaderAlert();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ButtonTopWidget(
            isPositioned: false,
            icon: iconCloseMenu,
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          Text(
            getIt<AppLocalizations>().titleFilter,
            style: const TextStyle(
                fontFamily: fontFamilyMontserrat,
                fontWeight: FontWeight.bold,
                color: secondaryColorTheme,
                fontSize: h3Size),
          ),
          const Spacer(),
          const SizedBox(
              width: 48), // Match ButtonTopWidget width for centering
        ],
      ),
    );
  }
}
