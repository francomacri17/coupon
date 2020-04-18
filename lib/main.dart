import 'package:coupon_app/src/blocs/login.bloc.dart';
import 'package:coupon_app/src/resources/blocProvider.dart';
import 'package:coupon_app/src/ui/home.page.dart';
import 'package:coupon_app/src/ui/login.page.dart';
import 'package:coupon_app/src/ui/signUp.page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context) => BlocProvider<LoginBloc>(
              bloc: LoginBloc(),
              child: LoginPage(),
            ),
        'signUp': (BuildContext context) => BlocProvider<LoginBloc>(
              bloc: LoginBloc(),
              child: SignUpPage(),
            ),
        //'home': (BuildContext context) => HomePage(),
      },
    );
  }
}
