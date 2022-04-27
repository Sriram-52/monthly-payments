import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:monthlypayments/constants/styles.dart';
import 'package:monthlypayments/services/Users/middleware/main.dart';
import 'package:monthlypayments/services/Users/model/main.dart';
import 'package:monthlypayments/services/Users/model/user.dart';
import 'package:monthlypayments/shared/widgets/base_widgets.dart';
import 'package:monthlypayments/store/app_state.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> with BaseWidgets {
  var nameController = TextEditingController();

  void callback() {
    Navigator.pop(context);
  }

  void _onSubmit() async {
    UserModel user = UserModel(
      fullName: nameController.text,
    );
    StoreProvider.of<AppState>(context).dispatch(addUser(user, callback));
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.only(bottom: 10);
    return StoreConnector<AppState, UsersState>(
      converter: (store) => store.state.usersState,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Add New User"),
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                Container(
                  padding: padding,
                  child: TextFormField(
                    controller: nameController,
                    onChanged: (val) => setEditingValue(val),
                    decoration: Styles.inputDecoration.copyWith(hintText: "Full Name"),
                  ),
                ),
                Builder(
                  builder: (context) {
                    return ElevatedButton(
                      onPressed: state.addUser.loading ? null : _onSubmit,
                      child: Text(
                        state.addUser.loading ? 'Adding...' : 'Add',
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
