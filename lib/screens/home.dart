import 'package:flutter/material.dart';
import 'package:monthlypayments/common/Loading.dart';
import 'package:monthlypayments/constants/styles.dart';
import 'package:monthlypayments/models/payment_model.dart';
import 'package:monthlypayments/screens/add_menu.dart';
import 'package:monthlypayments/screens/drawer.dart';
import 'package:monthlypayments/screens/sort_payments.dart';
import 'package:monthlypayments/services/payments.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PaymentsService _paymentsService = PaymentsService();

  String selectedUser = "PATXVkzzhIlLbt7MBla7"; // TODO: uId of room need to be dynamic

  void _showAddMenu() {
    if (selectedUser.isNotEmpty)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddMenu(uId: selectedUser),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly payments'),
      ),
      drawer: Drawer(child: UserDrawer()),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20),
                child: StreamBuilder<List<PaymentModel>>(
                  stream: _paymentsService.getPayments(selectedUser),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Loading();
                    final payments = snapshot.data ?? [];

                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Total: ${_paymentsService.getTotal(payments)}',
                            style: Styles.titleStyle,
                          ),
                        ),
                        Expanded(
                          child: SortPaymentsByDate(payments: payments),
                        ),
                        
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMenu,
        child: Icon(Icons.add),
      ),
    );
  }
}
