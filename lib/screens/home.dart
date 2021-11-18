import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:monthlypayments/constants/formatters.dart';
import 'package:monthlypayments/constants/styles.dart';
import 'package:monthlypayments/models/payment_model.dart';
import 'package:monthlypayments/models/user_model.dart';
import 'package:monthlypayments/screens/add_menu.dart';
import 'package:monthlypayments/screens/add_user.dart';
import 'package:monthlypayments/screens/drawer.dart';
import 'package:monthlypayments/screens/payment_card.dart';
import 'package:monthlypayments/services/payments.dart';
import 'package:monthlypayments/services/users.dart';

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
                      return Center(child: CircularProgressIndicator());
                    final payments = snapshot.data ?? [];

                    final paymentsByDate = groupBy(
                      payments,
                      (PaymentModel payment) => Formatters.timeStampToDate(
                        payment.purchasedDate,
                      ),
                    );

                    num total = 0;
                    payments.forEach((element) {
                      total += element.rate * element.quantity;
                    });

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
                              ...list.map((payment) => PaymentCard(payment: payment)).toList()
                            ],
                          ),
                        ),
                      );
                    });

                    return ListView(
                      children: [
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Total: $total',
                            style: Styles.titleStyle,
                          ),
                        ),
                        ..._children,
                        Container(
                          margin: EdgeInsets.only(bottom: 100),
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
