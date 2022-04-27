import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:monthlypayments/constants/formatters.dart';
import 'package:monthlypayments/constants/styles.dart';
import 'payment_card.dart';
import '../model/payment.dart';

class SortPaymentsByDate extends StatefulWidget {
  final List<PaymentModel> payments;
  final bool? isShare;
  final bool? isEdit;

  SortPaymentsByDate({
    required this.payments,
    this.isShare,
    this.isEdit,
  });

  @override
  _SortPaymentsByDateState createState() => _SortPaymentsByDateState();
}

class _SortPaymentsByDateState extends State<SortPaymentsByDate> {
  Map<String, List<PaymentModel>> _getPaymentsByDate(List<PaymentModel> payments) {
    return groupBy(
      payments,
      (PaymentModel payment) => Formatters.timeStampToDate(
        payment.purchasedDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentsByDate = _getPaymentsByDate(widget.payments);
    List<Widget> _children = [];

    paymentsByDate.forEach((date, list) {
      _children.add(
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  date,
                  style: Styles.subTitleStyle,
                ),
              ),
              ...list
                  .map((payment) => PaymentCard(
                        payment: payment,
                        isShare: widget.isShare,
                        isEdit: widget.isEdit,
                      ))
                  .toList(),
            ],
          ),
        ),
      );
    });

    return ListView(
      children: [
        ..._children,
        Container(
          margin: EdgeInsets.only(bottom: 100),
        ),
      ],
    );
  }
}
