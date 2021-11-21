import 'package:flutter/material.dart';
import 'package:monthlypayments/constants/styles.dart';
import 'package:monthlypayments/models/payment_model.dart';
import 'package:monthlypayments/screens/payment_card.dart';
import 'package:monthlypayments/services/payments.dart';

class SortPaymentsByDate extends StatefulWidget {
  final List<PaymentModel> payments;
  final bool? isShare;

  SortPaymentsByDate({
    required this.payments,
    this.isShare,
  });

  @override
  _SortPaymentsByDateState createState() => _SortPaymentsByDateState();
}

class _SortPaymentsByDateState extends State<SortPaymentsByDate> {
  final PaymentsService _paymentsService = PaymentsService();

  @override
  Widget build(BuildContext context) {
    final paymentsByDate = _paymentsService.getPaymentsByDate(widget.payments);
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
