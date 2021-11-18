import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';

class Formatters {
  static String timeStampToDate(Timestamp timestamp) {
    DateTime purchasedDate = timestamp.toDate();

    return Jiffy(purchasedDate).format('MMM do yyyy');
  }
}
