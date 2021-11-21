import 'package:flutter/material.dart';
import 'package:monthlypayments/common/Loading.dart';
import 'package:monthlypayments/constants/styles.dart';
import 'package:monthlypayments/constants/utils.dart';
import 'package:monthlypayments/models/payment_model.dart';
import 'package:monthlypayments/models/user_model.dart';
import 'package:monthlypayments/screens/sort_payments.dart';
import 'package:monthlypayments/services/payments.dart';

class Shares extends StatefulWidget {
  const Shares({Key? key}) : super(key: key);

  @override
  _SharesState createState() => _SharesState();
}

class _SharesState extends State<Shares> {
  final PaymentsService _paymentsService = PaymentsService();

  int _currentIndex = 0;

  PageController _pageController = PageController();

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

  String uId = usersList[0].uId ?? '';

  num totalAmount = 0;
  num spentAmount = 0;
  num amountToBePaid = 0;

  int _caluculateUserShare(List<PaymentModel> payments) {
    num total = 0;

    payments.forEach((payment) {
      total += (payment.rate / payment.users.length);
    });

    return total.ceil();
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
        onChanged: (val) => setState(() => uId = val ?? ''),
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

  _getPayments() {
    return Container(
      child: StreamBuilder<List<PaymentModel>>(
        stream: _paymentsService.getSelectedPayments(uId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Loading();

          final payments = snapshot.data ?? [];

          if (!snapshot.hasData)
            return Center(
              child: Text(
                'No Data',
              ),
            );

          totalAmount = _caluculateUserShare(payments);

          return SortPaymentsByDate(
            payments: payments,
            isShare: true,
          );
        },
      ),
    );
  }

  _getSpentPayments() {
    return Container(
      child: StreamBuilder<List<PaymentModel>>(
        stream: _paymentsService.getPaymentsMadeByUser(uId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Loading();

          final payments = snapshot.data ?? [];

          if (!snapshot.hasData)
            return Center(
              child: Text(
                'No Data',
              ),
            );

          spentAmount = _paymentsService.getTotal(payments);

          return SortPaymentsByDate(
            payments: payments,
          );
        },
      ),
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
    final List<Widget> _children = [
      _getPayments(),
      _getSpentPayments(),
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Shares'),
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
  }
}
