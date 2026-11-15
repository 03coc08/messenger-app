import 'package:flutter/material.dart';

/// Ô nhập dùng chung cho toàn app.
/// Ô thường và ô tìm kiếm chỉ khác nhau ở tham số truyền vào.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hint,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.isSearch = false,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.fillColor,
    this.border,
    this.contentPadding,
    this.minLines,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  /// true: ô tìm kiếm, có sẵn biểu tượng kính lúp và chữ gợi ý "Search".
  final bool isSearch;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  /// Màu nền. Bỏ trống thì lấy theo theme.
  final Color? fillColor;

  /// Viền. Bỏ trống thì lấy theo theme.
  final InputBorder? border;

  /// Khoảng đệm quanh chữ. Bỏ trống thì lấy theo theme (ô tìm kiếm gọn hơn).
  final EdgeInsetsGeometry? contentPadding;
  final int? minLines;
  final int? maxLines;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction:
          textInputAction ?? (isSearch ? TextInputAction.search : null),
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hint ?? (isSearch ? 'Search' : null),
        labelText: label,
        prefixIcon:
            prefixIcon ?? (isSearch ? const Icon(Icons.search_rounded) : null),
        suffixIcon: suffixIcon,
        filled: fillColor != null ? true : null,
        fillColor: fillColor,
        border: border,
        contentPadding:
            contentPadding ??
            (isSearch ? const EdgeInsets.symmetric(vertical: 11) : null),
      ),
    );
  }
}
