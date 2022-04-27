import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';
import '../actions/main.dart';
import '../../../store/app_state.dart';
import '../../../shared/functions/dispatcher.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

ThunkAction<AppState> addUser(UserModel user, Function callback) {
  return (Store<AppState> store) async {
    store.dispatch(dispatcher(ActionTypes.ADD_USER_REQ));
    try {
      Map<String, dynamic> payload = user.toMap();
      DocumentReference<Map<String, dynamic>> ref = _firebaseFirestore.collection("USERS").doc();
      await ref.set({
        ...payload,
        "id": ref.id,
        "isExist": true,
        "createdAt": Timestamp.now(),
      });
      callback();
      return store.dispatch(dispatcher(ActionTypes.ADD_USER_SUCCESS, []));
    } catch (e) {
      print(e);
      String errMsg = e.toString();
      return store.dispatch(dispatcher(ActionTypes.ADD_USER_FAILURE, errMsg));
    }
  };
}

ThunkAction<AppState> updateUser(UserModel updatedUser) {
  return (Store<AppState> store) async {
    store.dispatch(dispatcher(ActionTypes.UPDATE_USER_REQ));
    try {
      String id = updatedUser.uId!;
      DocumentReference<Map<String, dynamic>> ref = _firebaseFirestore.collection("USERS").doc(id);
      Map<String, dynamic> payload = updatedUser.toMap();
      await ref.update(payload);
      return store.dispatch(dispatcher(ActionTypes.UPDATE_USER_SUCCESS, []));
    } catch (e) {
      print(e);
      String errMsg = e.toString();
      return store.dispatch(dispatcher(ActionTypes.UPDATE_USER_FAILURE, errMsg));
    }
  };
}

ThunkAction<AppState> deleteUser(String id, Function callback) {
  return (Store<AppState> store) async {
    store.dispatch(dispatcher(ActionTypes.DELETE_USER_REQ));
    try {
      DocumentReference<Map<String, dynamic>> ref = _firebaseFirestore.collection("USERS").doc(id);
      DocumentSnapshot<Map<String, dynamic>> doc = await ref.get();
      if (doc.exists) {
        await ref.update({"isExist": false});
        callback();
        String msg = "User deleted successfully";
        return store.dispatch(dispatcher(ActionTypes.DELETE_USER_SUCCESS, msg));
      } else {
        String errMsg = "User already deleted or donot exists";
        return store.dispatch(dispatcher(ActionTypes.DELETE_USER_FAILURE, errMsg));
      }
    } catch (e) {
      print(e);
      String errMsg = e.toString();
      return store.dispatch(dispatcher(ActionTypes.DELETE_USER_FAILURE, errMsg));
    }
  };
}

ThunkAction<AppState> loadAllUsers() {
  return (Store<AppState> store) async {
    store.dispatch(dispatcher(ActionTypes.LOAD_ALL_USERS_REQ));
    _firebaseFirestore.collection("USERS").where("isExist", isEqualTo: true).snapshots().listen(
      (querySnapshot) {
        List<UserModel> users = querySnapshot.docs
            .map(
              (doc) => UserModel.fromJson(doc.data()),
            )
            .toList();
        return store.dispatch(dispatcher(ActionTypes.LOAD_ALL_USERS_SUCCESS, users));
      },
      onError: (e) {
        print(e);
        String errMsg = e.toString();
        return store.dispatch(dispatcher(ActionTypes.LOAD_ALL_USERS_FAILURE, errMsg));
      },
    );
  };
}

ThunkAction<AppState> loadSelectedUser(String id) {
  return (Store<AppState> store) async {
    store.dispatch(dispatcher(ActionTypes.LOAD_SELECTED_USER_REQ));
    _firebaseFirestore.doc("USERS/$id").snapshots().listen(
      (documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic>? data = documentSnapshot.data();
          UserModel user = UserModel.fromJson(data!);
          return store.dispatch(dispatcher(ActionTypes.LOAD_SELECTED_USER_SUCCESS, user));
        } else {
          String errMsg = "No User found";
          return store.dispatch(dispatcher(ActionTypes.LOAD_SELECTED_USER_FAILURE, errMsg));
        }
      },
      onError: (e) {
        print(e);
        String errMsg = e.toString();
        return store.dispatch(dispatcher(ActionTypes.LOAD_SELECTED_USER_FAILURE, errMsg));
      },
    );
  };
}
