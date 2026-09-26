import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';

class ModernSectionHeader extends StatelessWidget {
  final String title;
  const ModernSectionHeader({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: h4Size,
        fontWeight: FontWeight.bold,
        color: secondaryColorTheme,
        letterSpacing: 0.5,
      ),
    );
  }
}

class ModernFormCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  const ModernFormCard({super.key, required this.children, this.padding = const EdgeInsets.all(16.0)});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColorTheme,
        borderRadius: BorderRadius.circular(rounded10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? icon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int maxLines;
  final void Function(String)? onChanged;
  final bool obscureText;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;

  const ModernTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1,
    this.onChanged,
    this.obscureText = false,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: obscureText ? 1 : maxLines,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(fontSize: h4Size, color: appBarColorTheme),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, color: secondaryColorTheme, size: 20) : null,
        labelStyle: const TextStyle(color: grayTextColorTheme, fontSize: bodySize),
        hintStyle: const TextStyle(color: greyBlockColorTheme, fontSize: bodySize),
        filled: true,
        fillColor: backgroundColorTheme,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded10),
          borderSide: BorderSide(color: greyBlockColorTheme.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded10),
          borderSide: const BorderSide(color: secondaryColorTheme, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded10),
          borderSide: const BorderSide(color: cancelColorTheme),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded10),
          borderSide: const BorderSide(color: cancelColorTheme, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: paddingInput15),
      ),
    );
  }
}

class ModernDropdown<T> extends StatelessWidget {
  final String label;
  final IconData? icon;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const ModernDropdown({
    super.key,
    required this.label,
    this.icon,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: secondaryColorTheme),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: secondaryColorTheme, size: 20) : null,
        labelStyle: const TextStyle(color: grayTextColorTheme, fontSize: bodySize),
        filled: true,
        fillColor: backgroundColorTheme,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded10),
          borderSide: BorderSide(color: greyBlockColorTheme.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded10),
          borderSide: const BorderSide(color: secondaryColorTheme, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded10),
          borderSide: const BorderSide(color: cancelColorTheme),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rounded10),
          borderSide: const BorderSide(color: cancelColorTheme, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: paddingInput15),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemLabel(item),
            style: const TextStyle(fontSize: h4Size, color: appBarColorTheme),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
