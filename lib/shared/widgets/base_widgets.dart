import 'package:flutter/material.dart';

mixin BaseWidgets {
  TextEditingValue setEditingValue(String? val) {
    return TextEditingValue(
      text: val ?? "",
      selection: TextSelection.fromPosition(
        TextPosition(offset: val?.length ?? 0),
      ),
    );
  }
}
