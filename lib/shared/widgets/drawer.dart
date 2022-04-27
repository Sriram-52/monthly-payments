import 'package:flutter/material.dart';
import 'package:monthlypayments/services/Users/widgets/all_users.dart';
import '../../services/Payments/widgets/payment_details.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            child: Center(
              child: Text(
                'Expenses',
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentDetails()),
              );
            },
            title: Text('Payment Details'),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllUsers()),
              );
            },
            title: Text('Users'),
          ),
        ],
      ),
    );
  }
}
