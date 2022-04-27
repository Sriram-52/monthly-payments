import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/payment.dart';
import '../actions/main.dart';
import '../../../store/app_state.dart';
import '../../../shared/functions/dispatcher.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

ThunkAction<AppState> addPayment(PaymentModel payment, Function callback) {
  return (Store<AppState> store) async {
    store.dispatch(dispatcher(ActionTypes.ADD_PAYMENT_REQ));
    try {
      Map<String, dynamic> payload = payment.toMap();
      DocumentReference<Map<String, dynamic>> ref = _firebaseFirestore.collection("PAYMENTS").doc();
      await ref.set({
        ...payload,
        "id": ref.id,
        "isExist": true,
        "createdAt": Timestamp.now(),
      });
      callback();
      return store.dispatch(dispatcher(ActionTypes.ADD_PAYMENT_SUCCESS, []));
    } catch (e) {
      print(e);
      String errMsg = e.toString();
      return store.dispatch(dispatcher(ActionTypes.ADD_PAYMENT_FAILURE, errMsg));
    }
  };
}

ThunkAction<AppState> deletePayment(String id) {
  return (Store<AppState> store) async {
    store.dispatch(dispatcher(ActionTypes.DELETE_PAYMENT_REQ));
    try {
      DocumentReference<Map<String, dynamic>> ref =
          _firebaseFirestore.collection("PAYMENTS").doc(id);
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await ref.get();
      if (documentSnapshot.exists) {
        await ref.update({"isExist": false});
        return store.dispatch(dispatcher(ActionTypes.DELETE_PAYMENT_SUCCESS, []));
      } else {
        String errMsg = "Payment already deleted";
        return store.dispatch(dispatcher(ActionTypes.DELETE_PAYMENT_FAILURE, errMsg));
      }
    } catch (e) {
      print(e);
      String errMsg = e.toString();
      return store.dispatch(dispatcher(ActionTypes.DELETE_PAYMENT_FAILURE, errMsg));
    }
  };
}

ThunkAction<AppState> updatePayment(PaymentModel updatedPayment) {
  return (Store<AppState> store) async {
    store.dispatch(dispatcher(ActionTypes.UPDATE_PAYMENT_REQ));
    try {
      String id = updatedPayment.id!;
      DocumentReference<Map<String, dynamic>> ref =
          _firebaseFirestore.collection("PAYMENTS").doc(id);
      Map<String, dynamic> payload = updatedPayment.toMap();
      await ref.update(payload);
      return store.dispatch(dispatcher(ActionTypes.UPDATE_PAYMENT_SUCCESS, []));
    } catch (e) {
      print(e);
      String errMsg = e.toString();
      return store.dispatch(dispatcher(ActionTypes.UPDATE_PAYMENT_FAILURE, errMsg));
    }
  };
}

ThunkAction<AppState> loadPayment(String id) {
  return (Store<AppState> store) async {
    store.dispatch(dispatcher(ActionTypes.LOAD_PAYMENT_REQ));
    _firebaseFirestore.doc("PAYMENTS/$id").snapshots().listen(
      (documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic>? data = documentSnapshot.data();
          PaymentModel payment = PaymentModel.fromJson(data!);
          return store.dispatch(dispatcher(ActionTypes.LOAD_PAYMENT_SUCCESS, payment));
        } else {
          String errMsg = "Payment do not exists";
          return store.dispatch(dispatcher(ActionTypes.LOAD_PAYMENT_FAILURE, errMsg));
        }
      },
      onError: (e) {
        print(e);
        String errMsg = e.toString();
        return store.dispatch(dispatcher(ActionTypes.LOAD_PAYMENT_FAILURE, errMsg));
      },
    );
  };
}

ThunkAction<AppState> loadAllPayments() {
  return (Store<AppState> store) async {
    store.dispatch(dispatcher(ActionTypes.LOAD_ALL_PAYMENTS_REQ));
    _firebaseFirestore
        .collection("PAYMENTS")
        .where("isExist", isEqualTo: true)
        .orderBy('purchasedDate', descending: true)
        .snapshots()
        .listen(
      (querySnapshot) {
        List<PaymentModel> payments = querySnapshot.docs
            .map(
              (doc) => PaymentModel.fromJson(doc.data()),
            )
            .toList();
        return store.dispatch(dispatcher(ActionTypes.LOAD_ALL_PAYMENTS_SUCCESS, payments));
      },
      onError: (e) {
        print(e);
        String errMsg = e.toString();
        return store.dispatch(dispatcher(ActionTypes.LOAD_ALL_PAYMENTS_FAILURE, errMsg));
      },
    );
  };
}

ThunkAction<AppState> loadSelectedUserPurchases(String id) {
  return (Store<AppState> store) async {
    store.dispatch(dispatcher(ActionTypes.LOAD_SELECTED_USER_PURCHASES_REQ));
    _firebaseFirestore
        .collection("PAYMENTS")
        .where("isExist", isEqualTo: true)
        .where('users', arrayContains: id)
        .orderBy('purchasedDate', descending: true)
        .snapshots()
        .listen(
      (querySnapshot) {
        List<PaymentModel> payments = querySnapshot.docs
            .map(
              (doc) => PaymentModel.fromJson(doc.data()),
            )
            .toList();
        return store
            .dispatch(dispatcher(ActionTypes.LOAD_SELECTED_USER_PURCHASES_SUCCESS, payments));
      },
      onError: (e) {
        print(e);
        String errMsg = e.toString();
        return store.dispatch(dispatcher(ActionTypes.LOAD_SELECTED_USER_PURCHASES_FAILURE, errMsg));
      },
    );
  };
}

ThunkAction<AppState> loadSelectedUserPayments(String id) {
  return (Store<AppState> store) async {
    store.dispatch(dispatcher(ActionTypes.LOAD_SELECTED_USER_PAYMENTS_REQ));
    _firebaseFirestore
        .collection("PAYMENTS")
        .where("isExist", isEqualTo: true)
        .where('paymentMadeBy', isEqualTo: id)
        .orderBy('purchasedDate', descending: true)
        .snapshots()
        .listen(
      (querySnapshot) {
        List<PaymentModel> payments = querySnapshot.docs
            .map(
              (doc) => PaymentModel.fromJson(doc.data()),
            )
            .toList();
        return store.dispatch(dispatcher(
          ActionTypes.LOAD_SELECTED_USER_PAYMENTS_SUCCESS,
          payments,
        ));
      },
      onError: (e) {
        print(e);
        String errMsg = e.toString();
        return store.dispatch(dispatcher(ActionTypes.LOAD_SELECTED_USER_PAYMENTS_FAILURE, errMsg));
      },
    );
  };
}
