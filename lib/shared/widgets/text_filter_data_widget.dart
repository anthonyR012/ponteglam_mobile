import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/widgets/input_text_field_widget.dart';
import 'package:ponte_glam/shared/widgets/title_label_widget.dart';

class TextFilterData<T> extends StatefulWidget {
  final FocusNode? focusNode;
  final TextEditingController controller;
  final bool openSuggestionOnFocus;
  final int minSuggestions;
  final List<T> listItems;
  final bool obscureText;
  final bool enableSuggestions;
  final Widget Function(T suggestion)? itemBuilder;
  final void Function(T) onChanged;
  final StyleInputField styleInputField;
  final StyleTextItem? styleTextItem;

  const TextFilterData({
    super.key,
    required this.controller,
    required this.onChanged,
    this.styleInputField = const StyleInputField(textLabel: ""),
    this.styleTextItem,
    this.focusNode,
    this.enableSuggestions = true,
    this.itemBuilder,
    this.listItems = const [],
    this.obscureText = false,
    this.minSuggestions = 5,
    this.openSuggestionOnFocus = false,
  });

  @override
  State<TextFilterData<T>> createState() => _TextFilterDataState<T>();
}

class _TextFilterDataState<T> extends State<TextFilterData<T>> {
  List<T> filteredSuggestions = [];
  int lastCharacterCount = 0;
  StyleTextItem styleTextItem = const StyleTextItem(
    fontSize: h4Size,
    textAlign: TextAlign.start,
    maxLines: 2,
    fontWeight: FontWeight.normal,
    colorText: grayTextColorTheme,
  );

  @override
  void initState() {
    filteredSuggestions = widget.listItems;
    styleTextItem = widget.styleTextItem ?? styleTextItem;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _CompositedTextFieldItem<T>(
        iconHint: Icons.filter_tilt_shift_rounded,
        items: filteredSuggestions,
        onChange: widget.onChanged,
        styleInputField: widget.styleInputField,
        styleTextItem: styleTextItem,
        itemBuilder: widget.itemBuilder);
  }
}

class _CompositedTextFieldItem<T> extends StatefulWidget {
  const _CompositedTextFieldItem({
    super.key,
    required this.items,
    required this.onChange,
    required this.iconHint,
    required this.styleInputField,
    required this.styleTextItem,
    this.itemBuilder,
  });

  final IconData iconHint;
  final StyleInputField styleInputField;
  final StyleTextItem styleTextItem;
  final List<T> items;
  final void Function(T value) onChange;
  final Widget Function(T suggestion)? itemBuilder;

  @override
  State<_CompositedTextFieldItem<T>> createState() =>
      _CompositedTextFieldItemState<T>();
}

class _CompositedTextFieldItemState<T>
    extends State<_CompositedTextFieldItem<T>> {
  final LayerLink _layerLink = LayerLink();
  final OverlayPortalController _tooltipController = OverlayPortalController();
  final QueryTextNotifier<T> _queryTextNotifier = QueryTextNotifier<T>();

  @override
  void initState() {
    _queryTextNotifier.allList = widget.items;
    _queryTextNotifier.filteredSuggestions = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: _buildOverlayAlert(),
      ),
    );
  }

  OverlayPortal _buildOverlayAlert() {
    final width = MediaQuery.of(context).size.width;
    return OverlayPortal(
      controller: _tooltipController,
      overlayChildBuilder: (context) {
        return Material(
          color: Colors.transparent,
          type: MaterialType.transparency,
          child: SafeArea(
            child: Row(
              children: [
                _CompositedFollowerBuilder(
                  layerLink: _layerLink,
                  height: widget.styleInputField.height,
                  width: width,
                  titleUp: widget.styleInputField.textLabel,
                  itemBuilder: widget.itemBuilder,
                  onChange: widget.onChange,
                  tooltipController: _tooltipController,
                  queryTextNotifier: _queryTextNotifier,
                  styleTextItem: widget.styleTextItem,
                ),
              ],
            ),
          ),
        );
      },
      child: _PlaceholderSelectedItem(
          iconHint: widget.iconHint,
          tooltipController: _tooltipController,
          styleInputField: widget.styleInputField,
          queryTextNotifier: _queryTextNotifier),
    );
  }
}

class _CompositedFollowerBuilder<T> extends StatelessWidget {
  const _CompositedFollowerBuilder({
    super.key,
    required LayerLink layerLink,
    required this.width,
    required this.titleUp,
    required this.onChange,
    required this.tooltipController,
    required this.queryTextNotifier,
    required this.styleTextItem,
    this.itemBuilder,
    this.height,
  }) : _layerLink = layerLink;

  final LayerLink _layerLink;
  final String? titleUp;
  final double? height;
  final double width;
  final Widget Function(T suggestion)? itemBuilder;
  final void Function(T value) onChange;
  final OverlayPortalController tooltipController;
  final QueryTextNotifier<T> queryTextNotifier;
  final StyleTextItem styleTextItem;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformFollower(
      link: _layerLink,
      offset: Offset(0, height ?? 55),
      showWhenUnlinked: false,
      child: IntrinsicHeight(
        child: IntrinsicWidth(
          child: Container(
            constraints: BoxConstraints(
                maxWidth: width * 0.6, minWidth: width * 0.2, maxHeight: 300),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 2,
                  spreadRadius: 0.5,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextLabelWidget(
                    text: titleUp ?? '',
                    styleTextItem: styleTextItem.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: styleTextItem.fontSize + 1,
                    ),
                  ),
                  const Divider(),
                  ListenableBuilder(
                      listenable: queryTextNotifier,
                      builder: (context, snapshot) {
                        if (queryTextNotifier.filteredSuggestions.isEmpty) {
                          return TextLabelWidget(
                            text: getIt<AppLocalizations>().titleNoCoincidences,
                            styleTextItem: styleTextItem,
                          );
                        }
                        return _buildListItems(
                            queryTextNotifier.filteredSuggestions);
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListItems(List<T> items) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: queryTextNotifier.filteredSuggestions
          .map<Widget>(
              itemBuilder != null ? itemBuilder! : _buildItemDafaultDown)
          .toList(),
    );
  }

  Widget _buildItemDafaultDown(T value) {
    var valueFormat = value.toString();
    return InkWell(
      onTap: () {
        tooltipController.hide();
        onChange(value);
      },
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: TextLabelWidget(
          text: valueFormat,
          styleTextItem: styleTextItem,
        ),
      ),
    );
  }
}

class _PlaceholderSelectedItem<T> extends StatefulWidget {
  const _PlaceholderSelectedItem(
      {required this.iconHint,
      required this.styleInputField,
      required this.queryTextNotifier,
      required this.tooltipController});

  final IconData iconHint;
  final OverlayPortalController tooltipController;
  final StyleInputField styleInputField;
  final QueryTextNotifier<T> queryTextNotifier;

  @override
  State<_PlaceholderSelectedItem> createState() =>
      _PlaceholderSelectedItemState();
}

class _PlaceholderSelectedItemState extends State<_PlaceholderSelectedItem> {
  late final OverlayPortalController tooltipController;

  @override
  void initState() {
    tooltipController = widget.tooltipController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return InputTextField(
        onChanged: (value) {
          if (value.isNotEmpty && value.length < 2) {
            tooltipController.show();
          } else if (value.isEmpty) {
            tooltipController.hide();
            return;
          }
          widget.queryTextNotifier.filterSuggestions(value);
        },
        styleInputField: widget.styleInputField,
      );
    });
  }
}

class QueryTextNotifier<T> extends ChangeNotifier {
  String query = "";
  List<T> filteredSuggestions = [];
  List<T> allList = [];
  int lastCharacterCount = 0;

  void filterSuggestions([String query = ""]) {
    if (query.isEmpty) {
      filteredSuggestions = allList;
      notifyListeners();
      return;
    }
    if (query.length > lastCharacterCount) {
      filteredSuggestions = filteredSuggestions
          .where((item) =>
              item.toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      filteredSuggestions = allList
          .where((item) =>
              item.toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    lastCharacterCount = query.length;
    notifyListeners();
  }
}
