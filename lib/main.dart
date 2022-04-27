import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:monthlypayments/store/app_reducer.dart';
import 'package:monthlypayments/store/app_state.dart';
import 'package:monthlypayments/wrapper.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final _initialState = AppState.initialState();
  final _store = Store<AppState>(
    appReducer,
    initialState: _initialState,
    middleware: [
      thunkMiddleware,
    ],
  );
  runApp(MyApp(store: _store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  const MyApp({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
