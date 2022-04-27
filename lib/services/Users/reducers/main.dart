import '../actions/main.dart';
import '../model/main.dart';
import '../../../shared/models/redux_model.dart';

UsersState usersReducer(UsersState prevState, dynamic action) {
  UsersState newState = UsersState.fromAnotherState(prevState);

  String type = (action as DispatcherModel).type;
  dynamic payload = (action as DispatcherModel).payload;

  switch (type) {
    case ActionTypes.ADD_USER_REQ:
      return newState
        ..addUser.loading = true
        ..addUser.error = null;

    case ActionTypes.ADD_USER_SUCCESS:
      return newState
        ..addUser.loading = false
        ..addUser.data = payload;

    case ActionTypes.ADD_USER_FAILURE:
      return newState
        ..addUser.loading = false
        ..addUser.error = payload;

    case ActionTypes.UPDATE_USER_REQ:
      return newState
        ..updateUser.loading = true
        ..updateUser.error = null;

    case ActionTypes.UPDATE_USER_SUCCESS:
      return newState
        ..updateUser.loading = false
        ..updateUser.data = payload;

    case ActionTypes.UPDATE_USER_FAILURE:
      return newState
        ..updateUser.loading = false
        ..updateUser.error = payload;

    case ActionTypes.DELETE_USER_REQ:
      return newState
        ..deleteUser.loading = true
        ..deleteUser.error = null;

    case ActionTypes.DELETE_USER_SUCCESS:
      return newState
        ..deleteUser.loading = false
        ..deleteUser.data = payload;

    case ActionTypes.DELETE_USER_FAILURE:
      return newState
        ..deleteUser.loading = false
        ..deleteUser.error = payload;

    case ActionTypes.LOAD_ALL_USERS_REQ:
      return newState
        ..loadAllUsers.loading = true
        ..loadAllUsers.error = null;

    case ActionTypes.LOAD_ALL_USERS_SUCCESS:
      return newState
        ..loadAllUsers.loading = false
        ..loadAllUsers.data = payload;

    case ActionTypes.LOAD_ALL_USERS_FAILURE:
      return newState
        ..loadAllUsers.loading = false
        ..loadAllUsers.error = payload;

    case ActionTypes.LOAD_SELECTED_USER_REQ:
      return newState
        ..loadSelectedUser.loading = true
        ..loadSelectedUser.error = null;

    case ActionTypes.LOAD_SELECTED_USER_SUCCESS:
      return newState
        ..loadSelectedUser.loading = false
        ..loadSelectedUser.data = payload;

    case ActionTypes.LOAD_SELECTED_USER_FAILURE:
      return newState
        ..loadSelectedUser.loading = false
        ..loadSelectedUser.error = payload;

    default:
      return newState;
  }
}
