import 'package:flutter/material.dart';
import 'package:monthlypayments/models/payment_model.dart';
import 'package:monthlypayments/models/user_model.dart';
import 'package:monthlypayments/screens/add_menu.dart';
import 'package:monthlypayments/screens/add_user.dart';
import 'package:monthlypayments/services/payments.dart';
import 'package:monthlypayments/services/users.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UsersService _usersService = UsersService();
  final PaymentsService _paymentsService = PaymentsService();

  String selectedUser = "";

  void _showAddMenu() {
    if (selectedUser.isNotEmpty)
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            child: AddMenu(
              uId: selectedUser,
            ),
          );
        },
      );
  }

  void _showAddUser() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: AddUser(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly payments'),
        actions: [
          ElevatedButton(
            onPressed: _showAddUser,
            child: Text('Add User'),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            StreamBuilder<List<UserModel>>(
                stream: _usersService.getUsers(),
                builder: (context, snapshot) {
                  final users = snapshot.data ?? [];
                  return DropdownButtonFormField<String?>(
                    items: users.map((user) {
                      return DropdownMenuItem<String?>(
                        child: Text(user.fullName),
                        value: user.uId,
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedUser = val ?? ''),
                  );
                }),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20),
                child: StreamBuilder<List<PaymentModel>>(
                  stream: _paymentsService.getPayments(selectedUser),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    final payments = snapshot.data ?? [];
                    num total = 0;
                    payments.forEach((element) {
                      total += element.rate * element.quantity;
                    });
                    return ListView(
                      children: [
                        Text('Total: $total'),
                        ...payments.map((payment) {
                          return Card(
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(payment.description),
                                  Text(payment.purchasedDate.toDate().toIso8601String())
                                ],
                              ),
                              trailing: Text('${payment.rate * payment.quantity}'),
                            ),
                          );
                        }).toList()
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
