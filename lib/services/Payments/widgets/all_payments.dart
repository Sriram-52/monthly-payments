import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:monthlypayments/common/Loading.dart';
import 'package:monthlypayments/constants/styles.dart';
import 'package:monthlypayments/services/Payments/widgets/new_payment.dart';
import '../model/payment.dart';
import 'package:monthlypayments/services/Payments/middleware/main.dart';
import 'sort_payments.dart';
import 'package:monthlypayments/shared/widgets/error_feedback.dart';
import '../model/main.dart';
import '../../../shared/widgets/drawer.dart';
import '../../../store/app_state.dart';

class AllPayments extends StatelessWidget {
  const AllPayments({Key? key}) : super(key: key);

  num _getTotal(List<PaymentModel> payments) {
    num total = 0;

    payments.forEach((element) {
      total += element.rate;
    });

    return total;
  }

  @override
  Widget build(BuildContext context) {
    void _showAddMenu() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPayment(
            isEdit: false,
          ),
        ),
      );
    }

    return StoreConnector<AppState, PaymentsState>(
      converter: (store) => store.state.paymentsState,
      onInit: (store) {
        store.dispatch(loadAllPayments());
      },
      builder: (context, state) {
        final allPayments = state.loadAllPayments;
        if (allPayments.loading) return Loading();

        if (allPayments.error?.isNotEmpty == true) return ErrorFeedback(allPayments.error!);

        List<PaymentModel> payments = allPayments.data;

        return Scaffold(
          appBar: AppBar(
            title: Text('Expenses'),
          ),
          drawer: Drawer(
            child: UserDrawer(),
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Total: ${_getTotal(payments)}',
                      style: Styles.titleStyle,
                    ),
                  ),
                  Expanded(
                    child: SortPaymentsByDate(payments: payments),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddMenu,
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
