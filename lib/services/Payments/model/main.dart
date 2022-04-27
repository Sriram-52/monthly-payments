import '../../../shared/models/redux_model.dart';

class PaymentsState {
  ReduxDataModel addPayment;
  ReduxDataModel deletePayment;
  ReduxDataModel updatePayment;
  ReduxDataModel loadPayment;
  ReduxDataModel loadAllPayments;
  ReduxDataModel loadSelectedUserPurchases;
  ReduxDataModel loadSelectedUserPayments;

  PaymentsState({
    required this.addPayment,
    required this.deletePayment,
    required this.updatePayment,
    required this.loadPayment,
    required this.loadAllPayments,
    required this.loadSelectedUserPurchases,
    required this.loadSelectedUserPayments,
  });

  PaymentsState.initialState()
      : addPayment = ReduxDataModel.initialState(),
        deletePayment = ReduxDataModel.initialState(),
        updatePayment = ReduxDataModel.initialState(),
        loadPayment = ReduxDataModel.initialState()..loading = true,
        loadAllPayments = ReduxDataModel.initialState()..loading = true,
        loadSelectedUserPurchases = ReduxDataModel.initialState()..loading = true,
        loadSelectedUserPayments = ReduxDataModel.initialState()..loading = true;

  factory PaymentsState.fromAnotherState(PaymentsState another) {
    return PaymentsState(
      addPayment: another.addPayment,
      deletePayment: another.deletePayment,
      updatePayment: another.updatePayment,
      loadPayment: another.loadPayment,
      loadAllPayments: another.loadAllPayments,
      loadSelectedUserPurchases: another.loadSelectedUserPurchases,
      loadSelectedUserPayments: another.loadSelectedUserPayments,
    );
  }
}
