import 'dart:async';
import 'package:coupon_app/src/blocs/validators.bloc.dart';
import 'package:coupon_app/src/resources/blocProvider.dart';
import 'package:coupon_app/src/resources/firebaseProvider.dart';
import 'package:coupon_app/src/resources/firebaseRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators, ChangeNotifier implements BlocBase {
  FirebaseRepository _repository;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // State variables
  bool _loggedIn = false;
  bool _loading = false;

  bool isLoggedIn() {
    _loading = true;
    notifyListeners();
    _firebaseAuth.currentUser().then((FirebaseUser user) {
      _userController.sink.add(user);
    });
    if (user != null) {
      _loggedIn = true;
      _loading = false;
      notifyListeners();
    }
    return _loggedIn;
  }

  bool isLoading() => _loading;

  // Stream Controller
  BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  BehaviorSubject<String> _passwordController = BehaviorSubject<String>();
  BehaviorSubject<FirebaseUser> _userController =
      BehaviorSubject<FirebaseUser>();

  // Stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePassword);
  Stream<bool> get formValidForm =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);
  Stream<FirebaseUser> get userStream => _userController.stream;

  Function(FirebaseUser) get changeUser => _userController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  String get email => _emailController.value;
  String get password => _passwordController.value;
  FirebaseUser get user => _userController.value;

  LoginBloc() {
    _repository = FirebaseRepository();
    _firebaseAuth.currentUser().then((FirebaseUser user) {
      _userController.sink.add(user);
    });
  }

  login(LoginProviders loginProvider) async {
    _loading = true;
    notifyListeners();

    if (user != null) {
      _loggedIn = true;
      _loading = false;
      notifyListeners();
      return;
    }

    _repository
        .login(loginProvider, this.email, this.password)
        .then((FirebaseUser firebaseUser) {
      _userController.sink.add(firebaseUser);
      _loading = false;
      if (firebaseUser != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  dispose() {
    _emailController.close();
    _passwordController.close();
    _userController.close();
  }
}
