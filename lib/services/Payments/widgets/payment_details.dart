import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:monthlypayments/common/Loading.dart';
import 'package:monthlypayments/constants/styles.dart';
import 'package:monthlypayments/services/Payments/middleware/main.dart';
import 'package:monthlypayments/services/Payments/model/main.dart';
import 'package:monthlypayments/services/Payments/model/payment.dart';
import 'package:monthlypayments/services/Payments/widgets/sort_payments.dart';
import 'package:monthlypayments/services/Users/model/user.dart';
import 'package:monthlypayments/shared/widgets/error_feedback.dart';
import 'package:monthlypayments/store/app_state.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({Key? key}) : super(key: key);

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  int _currentIndex = 0;
  String uId = '';

  PageController _pageController = PageController();

  num totalAmount = 0;
  num spentAmount = 0;
  num amountToBePaid = 0;

  List<UserModel> usersList = [];

  bool isSetting = true;

  int _caluculateUserShare(List<PaymentModel> payments) {
    num total = 0;

    payments.forEach((payment) {
      total += (payment.rate / payment.users.length);
    });

    return total.ceil();
  }

  num _getTotal(List<PaymentModel> payments) {
    num total = 0;

    payments.forEach((element) {
      total += element.rate;
    });

    return total;
  }

  void _changePage(int pageNum) {
    setState(() {
      _currentIndex = pageNum;
      _pageController.animateToPage(
        pageNum,
        duration: Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  _getDropDown() {
    DropdownMenuItem<String?> _buildDropDownMenuItem(UserModel user) {
      return DropdownMenuItem<String?>(
        child: Text(user.fullName),
        value: user.uId,
      );
    }

    return Container(
      child: DropdownButtonFormField<String?>(
        items: usersList.map(_buildDropDownMenuItem).toList(),
        value: uId,
        onChanged: (val) {
          String _uId = val ?? '';
          setState(() => uId = _uId);
          StoreProvider.of<AppState>(context).dispatch(loadSelectedUserPayments(_uId));
          StoreProvider.of<AppState>(context).dispatch(loadSelectedUserPurchases(_uId));
        },
        decoration: Styles.inputDecoration.copyWith(hintText: 'Please select user'),
      ),
    );
  }

  _getInvoice() {
    _getChild(String title, num value) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    print('spentAmount: $spentAmount');

    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          _getChild('Grand Total', totalAmount),
          _getChild('Amount Spent', -spentAmount),
          _getChild('Total', totalAmount - spentAmount)
        ],
      ),
    );
  }

  _getPayments(PaymentsState paymentsState) {
    final selected = paymentsState.loadSelectedUserPurchases;
    if (selected.loading) return Loading();

    if (selected.error?.isNotEmpty == true) return ErrorFeedback(selected.error!);

    print('[selectedData] ${selected.data}');

    List<PaymentModel> payments = selected.data;

    totalAmount = _caluculateUserShare(payments);

    return SortPaymentsByDate(
      payments: payments,
      isShare: true,
      isEdit: false,
    );
  }

  _getSpentPayments(PaymentsState paymentsState) {
    final selected = paymentsState.loadSelectedUserPayments;

    if (selected.loading) return Loading();

    if (selected.error?.isNotEmpty == true) return ErrorFeedback(selected.error!);

    final payments = selected.data;

    spentAmount = _getTotal(payments);

    return SortPaymentsByDate(
      payments: payments,
      isEdit: false,
    );
  }

  _getTabViews() {
    _getTabButton(String title, int index) {
      return GestureDetector(
        onTap: () {
          _changePage(index);
          FocusScope.of(context).unfocus();
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          curve: Curves.fastLinearToSlowEaseIn,
          decoration: BoxDecoration(
              color: _currentIndex == index ? Colors.blueAccent : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.fromBorderSide(BorderSide(
                width: 1,
              ))),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.03,
            width: MediaQuery.of(context).size.width * 0.17,
            child: Center(child: Text(title)),
          ),
        ),
      );
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _getTabButton('Total', 0),
          _getTabButton('Spent', 1),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInitialBuild: (state) {
        List<UserModel> _usersList = state.usersState.loadAllUsers.data;
        setState(() {
          usersList = _usersList;
        });
        if (_usersList.isNotEmpty) {
          final _uId = _usersList[0].uId!;
          setState(() {
            uId = _uId;
          });
          StoreProvider.of<AppState>(context).dispatch(loadSelectedUserPayments(_uId));
          StoreProvider.of<AppState>(context).dispatch(loadSelectedUserPurchases(_uId));
        }
        setState(() {
          isSetting = false;
        });
      },
      builder: (context, state) {
        return isSetting
            ? Loading()
            : Builder(
                builder: (context) {
                  final List<Widget> _children = [
                    _getPayments(state.paymentsState),
                    _getSpentPayments(state.paymentsState),
                  ];
                  return DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text('Payment Details'),
                      ),
                      body: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            _getDropDown(),
                            _getInvoice(),
                            _getTabViews(),
                            Expanded(
                              child: PageView(
                                onPageChanged: (int page) {
                                  setState(() {
                                    _currentIndex = page;
                                  });
                                },
                                controller: _pageController,
                                children: _children,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}
