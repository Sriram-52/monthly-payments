import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:monthlypayments/constants/styles.dart';
import 'package:monthlypayments/constants/utils.dart';
import 'package:monthlypayments/models/payment_model.dart';
import 'package:monthlypayments/services/payments.dart';
import 'package:monthlypayments/services/users.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

final now = DateTime.now();

class AddMenu extends StatefulWidget {
  final String uId;

  AddMenu({required this.uId});

  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  String title = "";
  String description = "";
  num rate = 0;
  int quantity = 1;
  DateTime purchasedDate = DateTime(now.year, now.month, now.day);
  String paymentMadeBy = "wyCJA4akvInqijPuE7jG";
  List selectedUsers = usersList.map((e) => e.uId).toList();

  bool isLoading = false;

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
        users: selectedUsers,
        title: title,
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
    const padding = EdgeInsets.only(bottom: 10);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Payment"),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
        child: ListView(
          children: [
            Container(
              padding: padding,
              child: TextFormField(
                onChanged: (val) => setState(() => title = val),
                decoration: Styles.inputDecoration.copyWith(hintText: "Title"),
              ),
            ),
            Container(
              padding: padding,
              child: TextFormField(
                onChanged: (val) => setState(() => description = val),
                minLines: 5,
                maxLines: 15,
                decoration: Styles.inputDecoration.copyWith(hintText: "Description"),
              ),
            ),
            Container(
              padding: padding,
              child: TextFormField(
                onChanged: (val) => setState(() => rate = num.parse(val)),
                decoration: Styles.inputDecoration.copyWith(hintText: "Rate"),
              ),
            ),
            // Container(
            //   padding: padding,
            //   child: TextFormField(
            //     onChanged: (val) => setState(() => quantity = int.parse(val)),
            //     decoration: Styles.inputDecoration.copyWith(hintText: "Quantity"),
            //   ),
            // ),
            Container(
              padding: padding,
              child: DateTimeField(
                onDateSelected: (val) => setState(() => purchasedDate = val),
                decoration: Styles.inputDecoration.copyWith(hintText: "Purchased Date"),
                selectedDate: purchasedDate,
                mode: DateTimeFieldPickerMode.date,
              ),
            ),
            Container(
              padding: padding,
              child: DropdownButtonFormField<String?>(
                items: usersList.map((user) {
                  return DropdownMenuItem<String?>(
                    child: Text(user.fullName),
                    value: user.uId,
                  );
                }).toList(),
                onChanged: (val) => setState(() => paymentMadeBy = val ?? ''),
                decoration: Styles.inputDecoration.copyWith(hintText: "Payment made by"),
              ),
            ),
            Builder(builder: (context) {
              var _items = usersList
                  .map(
                    (user) => MultiSelectItem<String?>(
                      user.uId!,
                      user.fullName,
                    ),
                  )
                  .toList();

              return MultiSelectChipField(
                items: _items,
                initialValue: usersList.map((e) => e.uId).toList(),
                title: Text("Users include"),
                headerColor: Colors.blue.withOpacity(0.5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 1.8),
                ),
                selectedChipColor: Colors.blue.withOpacity(0.5),
                selectedTextStyle: TextStyle(color: Colors.blue[800]),
                onTap: (values) {
                  selectedUsers = values;
                },
              );
            }),
            ElevatedButton(
              onPressed: _onSubmit,
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
