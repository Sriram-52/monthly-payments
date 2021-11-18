import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monthlypayments/models/payment_model.dart';

class PaymentsService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addPayment(PaymentModel model) async {
    try {
      var docRef = _firebaseFirestore.collection('PAYMENTS').doc();
      var payload = model.toMap();

      payload["id"] = docRef.id;
      payload["isExist"] = true;

      return docRef.set(payload);
    } catch (e) {
      throw e;
    }
  }

  List<PaymentModel> _paymentsFromFirebase(QuerySnapshot<Map<String, dynamic>> querySnapshot) {
    return querySnapshot.docs.map((doc) => PaymentModel.fromJson(doc.data())).toList();
  }

  Stream<List<PaymentModel>> getPayments(String uId) {
    return _firebaseFirestore
        .collection('PAYMENTS')
        .where('uId', isEqualTo: uId)
        .where('isExist', isEqualTo: true)
        .orderBy('purchasedDate', descending: true)
        .snapshots()
        .map(_paymentsFromFirebase);
  }
}
