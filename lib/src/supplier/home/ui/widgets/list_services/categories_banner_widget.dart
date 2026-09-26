
import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/category_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoriesListSupplier extends StatefulWidget {
  const CategoriesListSupplier(
      {super.key,
      required this.height,
      required this.width,
      required this.onTapCategory});
  final double height;
  final double width;
  final void Function(CategoryModel) onTapCategory;

  @override
  State<CategoriesListSupplier> createState() => _CategoriesListSupplierState();
}

class _CategoriesListSupplierState extends State<CategoriesListSupplier> {
  bool _isLoading = true;
  bool _firstLoad = true;
  List<CategoryModel> _categories = [];
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    _getCategories(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state is GetCategoriesLoaded) {
            _categories = state.categories;
            _selectedCategory = getIt<SettingBloc>().categorySelected;
            if (_selectedCategory == null) {
              _selectedCategory = _categories.first;
              getIt<SettingBloc>().categorySelected = _selectedCategory;
            }
            if (_firstLoad) {
              _firstLoad = false;
              var filter = getIt<ServiceBloc>().filterService;
              filter = filter.copyWith(
                  category: _selectedCategory?.id, isFirstLoad: true);
              context
                  .read<HomeBloc>()
                  .add(DoGetServicesEvent(filterService: filter));
            }
            setState(() {
              _isLoading = false;
            });
          }
        },
        child:
            _buildListCategories(_selectedCategory, _isLoading, _categories));
  }

  Column _buildListCategories(CategoryModel? selectedCategory, bool isLoading,
      List<CategoryModel> categories) {
    return Column(
      children: [
        if (selectedCategory != null)
          _getBannerSelectedCategory(selectedCategory, isLoading: isLoading),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: !isLoading
                  ? List.generate(
                      categories.length,
                      (index) => _getItemCategoryBanner(categories[index],
                          isSelected: (selectedCategory?.id ?? -1) ==
                              categories[index].id))
                  : List.generate(
                      5,
                      (index) => _getItemCategoryBanner(
                          categoryModelFromJson("{}"),
                          isLoading: true)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getItemCategoryBanner(CategoryModel category,
      {bool isSelected = false, bool isLoading = false}) {
    return Skeletonizer(
      enabled: isLoading,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        onTap: () => isLoading ? null : widget.onTapCategory(category),
        child: Padding(
          padding: const EdgeInsets.only(left: 2, right: 2),
          child: Container(
            height: widget.height * 0.6,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: isLoading
                ? null
                : BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(rounded28)),
                    border: isSelected
                        ? Border.all(color: secondaryColorTheme)
                        : null,
                    color: isSelected ? null : secondaryColorTheme),
            child: Center(
              child: Text(
                isLoading ? ("_" * 2) : category.description,
                style: TextStyle(
                    color: isSelected ? secondaryColorTheme : whiteColorTheme,
                    fontFamily: fontFamilyMontserrat,
                    fontWeight: FontWeight.bold,
                    fontSize: h5Size + 2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getBannerSelectedCategory(CategoryModel category,
      {bool isLoading = false}) {
    final currentColor = "0xFF${category.color}";
    return Skeletonizer(
      enabled: isLoading,
      child: SizedBox(
        height: widget.height,
        child: OverflowBox(
          maxWidth: widget.width,
          maxHeight: widget.height,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            height: 100,
            color: isLoading ? Colors.white : Color(int.parse(currentColor)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isLoading ? ("_" * 2) : category.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: fontFamilyMontserrat,
                        fontSize: h3Size,
                        fontWeight: FontWeight.bold,
                        color: whiteColorTheme),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 110,
                  child: Transform.translate(
                    offset: const Offset(-20, 0),
                    child: isLoading
                        ? const Skeleton.shade(child: CircleAvatar(radius: 10))
                        : ImageLoadWidget(
                            image: category.picture,
                            typeSourceImage: TypeSourceImage.file,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _getCategories({required BuildContext context}) async {
    context
        .read<SettingBloc>()
        .add(const DoGetCategoriesEvent());
  }
}
