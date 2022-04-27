import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:monthlypayments/services/Users/middleware/main.dart';
import 'package:monthlypayments/services/Users/model/main.dart';
import 'package:monthlypayments/services/Users/model/user.dart';
import 'package:monthlypayments/store/app_state.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void callback() {}

    void _onDelete() {
      StoreProvider.of<AppState>(context).dispatch(deleteUser(user.uId!, callback));
    }

    return StoreConnector<AppState, UsersState>(
      converter: (store) => store.state.usersState,
      builder: (context, state) {
        return Container(
          child: Card(
            child: ListTile(
              title: Text(user.fullName),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: state.deleteUser.loading ? null : _onDelete,
              ),
            ),
          ),
        );
      },
    );
  }
}
