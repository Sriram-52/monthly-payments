import 'package:flutter/material.dart';

class ErrorFeedback extends StatelessWidget {
  final String errMsg;
  const ErrorFeedback(this.errMsg, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Text(errMsg),
    );
  }
}
