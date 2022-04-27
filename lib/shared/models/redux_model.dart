// every variable that is declared in the state should have redux model
class ReduxDataModel {
  bool loading;
  dynamic data;
  String? error;

  ReduxDataModel({
    required this.loading,
    required this.data,
    required this.error,
  });

  ReduxDataModel.initialState()
      : loading = false,
        data = {},
        error = null;
}

// action dispatcher model
class DispatcherModel {
  String type;
  dynamic payload;

  DispatcherModel({
    required this.type,
    required this.payload,
  });
}
