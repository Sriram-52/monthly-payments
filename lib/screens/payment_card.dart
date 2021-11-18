import 'package:flutter/material.dart';
import 'package:monthlypayments/constants/utils.dart';
import 'package:monthlypayments/models/payment_model.dart';
import 'package:monthlypayments/services/users.dart';

class PaymentCard extends StatefulWidget {
  final PaymentModel payment;

  PaymentCard({required this.payment});

  @override
  _PaymentCardState createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  late PaymentModel payment;

  @override
  void initState() {
    setState(() {
      payment = widget.payment;
    });
    super.initState();
  }

  final UsersService _usersService = UsersService();

  @override
  void didUpdateWidget(covariant PaymentCard oldWidget) {
    if (payment.id != widget.payment.id) {
      setState(() {
        payment = widget.payment;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget _buildChildren() {
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'Title',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Value',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Description')),
            DataCell(Text('${payment.description}')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Payment Made by')),
            DataCell(Text('${_usersService.nameFromUid(payment.paymentMadeBy)}')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Users include')),
            DataCell(
              Builder(
                builder: (context) {
                  var req = payment.users
                      .map(
                        (uId) => _usersService.nameFromUid(uId),
                      )
                      .toList()
                      .join(',');

                  return Text(req);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: ExpansionTile(
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          title: Text(payment.title),
          children: [_buildChildren()],
          trailing: Text('${payment.rate}'),
        ),
      ),
    );
  }
}
