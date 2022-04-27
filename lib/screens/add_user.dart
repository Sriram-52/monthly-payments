// import 'package:flutter/material.dart';
// import 'package:monthlypayments/models/user_model.dart';
// import 'package:monthlypayments/services/users.dart';

// class AddUser extends StatefulWidget {
//   const AddUser({Key? key}) : super(key: key);

//   @override
//   _AddUserState createState() => _AddUserState();
// }

// class _AddUserState extends State<AddUser> {
//   String fullName = "";

//   bool isLoading = false;

//   final UsersService _usersService = UsersService();

//   Future<void> _onSubmit() async {
//     try {
//       UserModel userModel = UserModel(fullName: fullName);
//       setState(() {
//         isLoading = true;
//       });
//       await _usersService.addUser(userModel);
//       setState(() {
//         isLoading = false;
//       });
//       Navigator.pop(context);
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print('$e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           TextFormField(
//             onChanged: (val) => setState(() => fullName = val),
//           ),
//           ElevatedButton(
//             onPressed: _onSubmit,
//             child: Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }
// }
