import 'package:coupon_app/src/blocs/login.bloc.dart';
import 'package:coupon_app/src/resources/blocProvider.dart';
import 'package:coupon_app/src/ui/login.page.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<LoginBloc>
      (
        bloc: LoginBloc(),
        child: LoginPage(),
      )
    );
    
  }
}