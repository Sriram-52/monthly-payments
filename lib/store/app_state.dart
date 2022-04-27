import 'package:monthlypayments/services/Payments/model/main.dart';
import 'package:monthlypayments/services/Users/model/main.dart';

class AppState {
  PaymentsState paymentsState;
  UsersState usersState;

  AppState({
    required this.paymentsState,
    required this.usersState,
  });

  AppState.initialState()
      : paymentsState = PaymentsState.initialState(),
        usersState = UsersState.initialState();

  factory AppState.fromAnotherAppState(AppState another) {
    return AppState(
      paymentsState: another.paymentsState,
      usersState: another.usersState,
    );
  }
}
