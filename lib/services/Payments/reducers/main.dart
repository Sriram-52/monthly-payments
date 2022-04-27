import '../actions/main.dart';
import '../model/main.dart';
import '../../../shared/models/redux_model.dart';

PaymentsState paymentsReducer(PaymentsState prevState, dynamic action) {
  PaymentsState newState = PaymentsState.fromAnotherState(prevState);

  String type = (action as DispatcherModel).type;
  dynamic payload = (action as DispatcherModel).payload;

  switch (type) {
    case ActionTypes.ADD_PAYMENT_REQ:
      return newState
        ..addPayment.loading = true
        ..addPayment.error = null;

    case ActionTypes.ADD_PAYMENT_SUCCESS:
      return newState
        ..addPayment.loading = false
        ..addPayment.data = payload;

    case ActionTypes.ADD_PAYMENT_FAILURE:
      return newState
        ..addPayment.loading = false
        ..addPayment.error = payload;

    case ActionTypes.DELETE_PAYMENT_REQ:
      return newState
        ..deletePayment.loading = true
        ..deletePayment.error = null;

    case ActionTypes.DELETE_PAYMENT_SUCCESS:
      return newState
        ..deletePayment.loading = false
        ..deletePayment.data = payload;

    case ActionTypes.DELETE_PAYMENT_FAILURE:
      return newState
        ..deletePayment.loading = false
        ..deletePayment.error = payload;

    case ActionTypes.UPDATE_PAYMENT_REQ:
      return newState
        ..updatePayment.loading = true
        ..updatePayment.error = null;

    case ActionTypes.UPDATE_PAYMENT_SUCCESS:
      return newState
        ..updatePayment.loading = false
        ..updatePayment.data = payload;

    case ActionTypes.UPDATE_PAYMENT_FAILURE:
      return newState
        ..updatePayment.loading = false
        ..updatePayment.error = payload;

    case ActionTypes.LOAD_PAYMENT_REQ:
      return newState
        ..loadPayment.loading = true
        ..loadPayment.error = null;

    case ActionTypes.LOAD_PAYMENT_SUCCESS:
      return newState
        ..loadPayment.loading = false
        ..loadPayment.data = payload;

    case ActionTypes.LOAD_PAYMENT_FAILURE:
      return newState
        ..loadPayment.loading = false
        ..loadPayment.error = payload;

    case ActionTypes.LOAD_ALL_PAYMENTS_REQ:
      return newState
        ..loadAllPayments.loading = true
        ..loadAllPayments.error = null;

    case ActionTypes.LOAD_ALL_PAYMENTS_SUCCESS:
      return newState
        ..loadAllPayments.loading = false
        ..loadAllPayments.data = payload;

    case ActionTypes.LOAD_ALL_PAYMENTS_FAILURE:
      return newState
        ..loadAllPayments.loading = false
        ..loadAllPayments.error = payload;

    case ActionTypes.LOAD_SELECTED_USER_PURCHASES_REQ:
      return newState
        ..loadSelectedUserPurchases.loading = true
        ..loadSelectedUserPurchases.error = null;

    case ActionTypes.LOAD_SELECTED_USER_PURCHASES_SUCCESS:
      return newState
        ..loadSelectedUserPurchases.loading = false
        ..loadSelectedUserPurchases.data = payload;

    case ActionTypes.LOAD_SELECTED_USER_PURCHASES_FAILURE:
      return newState
        ..loadSelectedUserPurchases.loading = false
        ..loadSelectedUserPurchases.error = payload;

    case ActionTypes.LOAD_SELECTED_USER_PAYMENTS_REQ:
      return newState
        ..loadSelectedUserPayments.loading = true
        ..loadSelectedUserPayments.error = null;

    case ActionTypes.LOAD_SELECTED_USER_PAYMENTS_SUCCESS:
      return newState
        ..loadSelectedUserPayments.loading = false
        ..loadSelectedUserPayments.data = payload;

    case ActionTypes.LOAD_SELECTED_USER_PAYMENTS_FAILURE:
      return newState
        ..loadSelectedUserPayments.loading = false
        ..loadSelectedUserPayments.error = payload;

    default:
      return newState;
  }
}
