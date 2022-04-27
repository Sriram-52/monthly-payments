import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:monthlypayments/common/Loading.dart';
import 'package:monthlypayments/services/Payments/widgets/all_payments.dart';
import 'package:monthlypayments/services/Users/middleware/main.dart';
import 'package:monthlypayments/services/Users/model/main.dart';
import 'package:monthlypayments/shared/widgets/error_feedback.dart';
import 'package:monthlypayments/store/app_state.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UsersState>(
      converter: (store) => store.state.usersState,
      onInit: (store) {
        store.dispatch(loadAllUsers());
      },
      builder: (context, state) {
        final allusers = state.loadAllUsers;

        if (allusers.loading)
          return Scaffold(
            body: Loading(),
          );

        if (allusers.error?.isNotEmpty == true)
          return Scaffold(
            body: ErrorFeedback(allusers.error!),
          );

        return AllPayments();
      },
    );
  }
}
