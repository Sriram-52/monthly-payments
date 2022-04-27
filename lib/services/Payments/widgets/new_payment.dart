import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:monthlypayments/common/Loading.dart';
import 'package:monthlypayments/constants/styles.dart';
import 'package:monthlypayments/services/Payments/middleware/main.dart';
import 'package:monthlypayments/services/Users/model/user.dart';
import '../model/payment.dart';
import 'package:monthlypayments/shared/widgets/base_widgets.dart';
import 'package:monthlypayments/store/app_state.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

final now = DateTime.now();

class NewPayment extends StatefulWidget {
  final PaymentModel? payment;
  final bool isEdit;
  const NewPayment({
    Key? key,
    this.payment,
    required this.isEdit,
  }) : super(key: key);

  @override
  State<NewPayment> createState() => _NewPaymentState();
}

class _NewPaymentState extends State<NewPayment> with BaseWidgets {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var rateController = TextEditingController();
  String paymentMadeBy = "";
  List selectedUsers = [];
  List<UserModel> usersList = [];
  DateTime purchasedDate = DateTime(now.year, now.month, now.day);

  @override
  void initState() {
    super.initState();
    if (widget.payment != null) {
      final payment = widget.payment!;
      titleController.value = setEditingValue(payment.title);
      descriptionController.value = setEditingValue(payment.description);
      rateController.value = setEditingValue(payment.rate.toString());
      setState(() {
        paymentMadeBy = payment.paymentMadeBy;
        selectedUsers = payment.users;
        purchasedDate = payment.purchasedDate.toDate();
      });
    }
  }

  bool isSetting = true;

  void callback() {
    Navigator.pop(context);
  }

  void _onSubmit() async {
    PaymentModel payment = PaymentModel(
      description: descriptionController.text,
      rate: num.parse(rateController.text),
      purchasedDate: Timestamp.fromDate(purchasedDate),
      paymentMadeBy: paymentMadeBy,
      users: selectedUsers,
      title: titleController.text,
    );
    StoreProvider.of<AppState>(context).dispatch(addPayment(payment, callback));
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.only(bottom: 10);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInitialBuild: (state) {
        List<UserModel> _usersList = state.usersState.loadAllUsers.data;
        if (!widget.isEdit) {
          setState(() {
            usersList = _usersList;
            selectedUsers = _usersList.map((e) => e.uId!).toList();
          });
          if (_usersList.isNotEmpty) {
            final _uId = _usersList[0].uId!;
            setState(() {
              paymentMadeBy = _uId;
            });
          }
          setState(() {
            isSetting = false;
          });
        } else {
          setState(() {
            usersList = _usersList;
            isSetting = false;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.isEdit ? "Payment" : "Add Payment"),
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            child: isSetting
                ? Loading()
                : ListView(
                    children: [
                      Container(
                        padding: padding,
                        child: TextFormField(
                          controller: titleController,
                          onChanged: (val) => setEditingValue(val),
                          decoration: Styles.inputDecoration.copyWith(hintText: "Title"),
                          readOnly: widget.isEdit,
                        ),
                      ),
                      Container(
                        padding: padding,
                        child: TextFormField(
                          controller: descriptionController,
                          onChanged: (val) => setEditingValue(val),
                          minLines: 5,
                          maxLines: 15,
                          decoration: Styles.inputDecoration.copyWith(hintText: "Description"),
                          readOnly: widget.isEdit,
                        ),
                      ),
                      Container(
                        padding: padding,
                        child: TextFormField(
                          controller: rateController,
                          onChanged: (val) => setEditingValue(val),
                          decoration: Styles.inputDecoration.copyWith(hintText: "Rate"),
                          readOnly: widget.isEdit,
                        ),
                      ),
                      Container(
                        padding: padding,
                        child: DateTimeField(
                          onDateSelected: (val) => setState(() => purchasedDate = val),
                          decoration: Styles.inputDecoration.copyWith(hintText: "Purchased Date"),
                          selectedDate: purchasedDate,
                          mode: DateTimeFieldPickerMode.date,
                          enabled: widget.isEdit,
                        ),
                      ),
                      Container(
                        padding: padding,
                        child: DropdownButtonFormField<String?>(
                          items: usersList.map(
                            (user) {
                              return DropdownMenuItem<String?>(
                                child: Text(user.fullName),
                                value: user.uId,
                              );
                            },
                          ).toList(),
                          onChanged: (val) => setState(() => paymentMadeBy = val ?? ''),
                          decoration: Styles.inputDecoration.copyWith(hintText: "Payment made by"),
                          value: paymentMadeBy,
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          var _items = usersList.map(
                            (user) {
                              return MultiSelectItem<String?>(
                                user.uId!,
                                user.fullName,
                              );
                            },
                          ).toList();

                          return MultiSelectChipField(
                            items: _items,
                            initialValue: widget.isEdit
                                ? widget.payment!.users.map((e) => e).toList()
                                : usersList.map((e) => e.uId).toList(),
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
                        },
                      ),
                      if (!widget.isEdit)
                        Builder(
                          builder: (context) {
                            final _paymentsState = state.paymentsState;
                            return ElevatedButton(
                              onPressed: _paymentsState.addPayment.loading ? null : _onSubmit,
                              child: Text(
                                _paymentsState.addPayment.loading ? 'Adding...' : 'Add',
                              ),
                            );
                          },
                        ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
