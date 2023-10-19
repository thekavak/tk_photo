import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class ThemeTextFormField extends StatelessWidget {
  const ThemeTextFormField(
      {super.key,
      required this.keyboardType,
      this.hintText,
      this.errorText,
      this.prefixIcon,
      this.textInputAction = TextInputAction.next,
      this.onChanged,
      this.controller});

  final String? hintText;
  final String? errorText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      style: context.textTheme.labelLarge?.copyWith(
          color: context.colorScheme.primary,
          fontWeight: FontWeight.w400,
          fontSize: 16),
      obscureText: keyboardType == TextInputType.visiblePassword ? true : false,
      keyboardType: keyboardType,
      textDirection: TextDirection.ltr,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          isDense: true,
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: context.colorScheme.primary,
                )
              : null,
          errorText: errorText,
          hintText: hintText ?? '',
          hintStyle: context.textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey),
          contentPadding: const EdgeInsets.all(16),
          isCollapsed: true),
      maxLines: 1,
      cursorColor: context.colorScheme.primary,
      onChanged: onChanged ?? (value) {},
    );
  }
}
