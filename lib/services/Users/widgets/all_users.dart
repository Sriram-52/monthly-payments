import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:monthlypayments/common/Loading.dart';
import 'package:monthlypayments/services/Users/middleware/main.dart';
import 'package:monthlypayments/services/Users/model/main.dart';
import 'package:monthlypayments/services/Users/model/user.dart';
import 'package:monthlypayments/services/Users/widgets/add_user.dart';
import 'package:monthlypayments/services/Users/widgets/user_card.dart';
import 'package:monthlypayments/shared/widgets/error_feedback.dart';
import 'package:monthlypayments/store/app_state.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _showAddMenu() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddUser(),
        ),
      );
    }

    return StoreConnector<AppState, UsersState>(
      converter: (store) => store.state.usersState,
      onInit: (store) {
        store.dispatch(loadAllUsers());
      },
      builder: (context, state) {
        final allUsers = state.loadAllUsers;
        if (allUsers.loading) return Loading();

        if (allUsers.error?.isNotEmpty == true) return ErrorFeedback(allUsers.error!);

        List<UserModel> users = allUsers.data;

        return Scaffold(
          appBar: AppBar(
            title: Text('All Users'),
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              child: ListView(
                children: users.map((user) => UserCard(user: user)).toList(),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddMenu,
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
