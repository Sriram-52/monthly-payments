import 'package:monthlypayments/services/Payments/reducers/main.dart';
import 'package:monthlypayments/services/Users/reducers/main.dart';

import 'app_state.dart';

AppState appReducer(AppState prevState, dynamic action) {
  return AppState(
    paymentsState: paymentsReducer(prevState.paymentsState, action),
    usersState: usersReducer(prevState.usersState, action),
  );
}
