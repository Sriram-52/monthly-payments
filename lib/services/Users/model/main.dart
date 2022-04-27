import '../../../shared/models/redux_model.dart';

class UsersState {
  ReduxDataModel addUser;
  ReduxDataModel updateUser;
  ReduxDataModel deleteUser;
  ReduxDataModel loadAllUsers;
  ReduxDataModel loadSelectedUser;

  UsersState({
    required this.addUser,
    required this.updateUser,
    required this.deleteUser,
    required this.loadAllUsers,
    required this.loadSelectedUser,
  });

  UsersState.initialState()
      : addUser = ReduxDataModel.initialState(),
        updateUser = ReduxDataModel.initialState(),
        deleteUser = ReduxDataModel.initialState(),
        loadAllUsers = ReduxDataModel.initialState()..loading = true,
        loadSelectedUser = ReduxDataModel.initialState()..loading = true;

  factory UsersState.fromAnotherState(UsersState another) {
    return UsersState(
      addUser: another.addUser,
      updateUser: another.updateUser,
      deleteUser: another.deleteUser,
      loadAllUsers: another.loadAllUsers,
      loadSelectedUser: another.loadSelectedUser,
    );
  }
}
