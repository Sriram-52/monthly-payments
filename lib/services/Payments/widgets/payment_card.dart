import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:monthlypayments/services/Payments/middleware/main.dart';
import 'package:monthlypayments/services/Payments/model/main.dart';
import 'package:monthlypayments/services/Payments/widgets/new_payment.dart';
import 'package:monthlypayments/store/app_state.dart';
import '../model/payment.dart';

class PaymentCard extends StatelessWidget {
  final PaymentModel payment;
  final bool? isShare;
  final bool? isEdit;

  const PaymentCard({
    Key? key,
    required this.payment,
    this.isShare,
    this.isEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void callback() {}

    void _onDelete() {
      StoreProvider.of<AppState>(context).dispatch(deletePayment(payment.id!));
    }

    return StoreConnector<AppState, PaymentsState>(
      converter: (store) => store.state.paymentsState,
      builder: (context, state) {
        return Container(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewPayment(
                    payment: payment,
                    isEdit: true,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: Text(payment.title),
                      trailing: isShare == true
                          ? Text('${(payment.rate / payment.users.length).floorToDouble()}')
                          : Text('${payment.rate}'),
                    ),
                  ),
                ),
                if (isEdit != false)
                  IconButton(
                    onPressed: state.deletePayment.loading ? null : _onDelete,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
