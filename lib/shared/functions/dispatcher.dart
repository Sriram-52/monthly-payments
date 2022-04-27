// utility function to dispatch an action
import '../models/redux_model.dart';

DispatcherModel dispatcher(String action, [dynamic payload]) {
  print('[redux]{Action: $action, Payload: $payload}');
  return DispatcherModel(type: action, payload: payload);
}
