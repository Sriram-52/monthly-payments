import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:monthlypayments/models/payment_model.dart';
import 'package:monthlypayments/models/user_model.dart';
import 'package:monthlypayments/services/payments.dart';
import 'package:monthlypayments/services/users.dart';

class AddMenu extends StatefulWidget {
  final String uId;

  AddMenu({required this.uId});

  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  String description = "";
  num rate = 0;
  int quantity = 1;
  DateTime purchasedDate = DateTime.now();
  String paymentMadeBy = "";

  bool isLoading = false;

  final UsersService _usersService = UsersService();
  final PaymentsService _paymentsService = PaymentsService();

  Future<void> _onSubmit() async {
    try {
      setState(() {
        isLoading = true;
      });
      PaymentModel paymentModel = PaymentModel(
        description: description,
        rate: rate,
        uId: widget.uId,
        quantity: quantity,
        purchasedDate: Timestamp.fromDate(purchasedDate),
        paymentMadeBy: paymentMadeBy,
      );
      await _paymentsService.addPayment(paymentModel);
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextFormField(
            onChanged: (val) => setState(() => description = val),
          ),
          TextFormField(
            onChanged: (val) => setState(() => rate = num.parse(val)),
          ),
          TextFormField(
            onChanged: (val) => setState(() => quantity = int.parse(val)),
          ),
          DateTimeField(
            onDateSelected: (val) => setState(() => purchasedDate = val),
            selectedDate: purchasedDate,
            mode: DateTimeFieldPickerMode.date,
          ),
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
                  onChanged: (val) => setState(() => paymentMadeBy = val ?? ''),
                );
              }),
          ElevatedButton(
            onPressed: _onSubmit,
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
