import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monthlypayments/models/user_model.dart';

class UsersService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addUser(UserModel user) async {
    try {
      var ref = _firebaseFirestore.collection('USERS').doc();
      var payload = user.toMap();

      payload["uId"] = ref.id;
      payload["createdAt"] = Timestamp.now();

      return ref.set(payload);
    } catch (e) {
      throw e;
    }
  }

  List<UserModel> _usersFromFirebase(QuerySnapshot<Map<String, dynamic>> querySnapshot) {
    return querySnapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }

  Stream<List<UserModel>> getUsers() {
    return _firebaseFirestore
        .collection('USERS')
        .orderBy('createdAt')
        .snapshots()
        .map(_usersFromFirebase);
  }
}
