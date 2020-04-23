import 'package:coupon_app/src/blocs/login.bloc.dart';
import 'package:coupon_app/src/resources/blocProvider.dart';
import 'package:coupon_app/src/ui/home.page.dart';
import 'package:coupon_app/src/ui/login.page.dart';
import 'package:coupon_app/src/ui/signUp.page.dart';
import 'package:coupon_app/src/ui/splash.page.dart';
import 'package:coupon_app/src/userPreferences/userPreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: this.getCurrentUser() != null ? 'home' : 'login',
      routes: {
        'splash': (BuildContext context) => BlocProvider<LoginBloc>(
              bloc: LoginBloc(),
              child: SplashPage(),
            ),
        'login': (BuildContext context) => BlocProvider<LoginBloc>(
              bloc: LoginBloc(),
              child: LoginPage(),
            ),
        'signUp': (BuildContext context) => BlocProvider<LoginBloc>(
              bloc: LoginBloc(),
              child: SignUpPage(),
            ),
        'home': ((BuildContext context) => BlocProvider<LoginBloc>(
              bloc: LoginBloc(),
              child: HomePage(),
            ))
      },
    );
  }

  Future getCurrentUser() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    print("User: ${_user.displayName ?? "None"}");
    return _user;
  }
}
