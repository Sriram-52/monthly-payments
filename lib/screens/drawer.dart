import 'package:flutter/material.dart';
import 'package:monthlypayments/screens/shares.dart';

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
                'Monthly payments',
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
                MaterialPageRoute(builder: (context) => Shares()),
              );
            },
            title: Text('Shares'),
          ),
        ],
      ),
    );
  }
}
