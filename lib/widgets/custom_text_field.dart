import 'package:base_project/utls/colors.dart';
import 'package:base_project/utls/styles.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.lablel,
    this.hint,
    this.controller,
    this.focusNode,
  });
  final String? lablel;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        label: Text(
          lablel ?? '',
          style: tsS14W500.copyWith(color: primaryButtonColor),
        ),
        hintText: hint,
        hintStyle: tsS14W400.copyWith(color: secondaryTextColor),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: colorDivider),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorBlack),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorBlack),
        ),
      ),
    );
  }
}
